require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.2.3.tgz"
  sha256 "689e4936f012aad2b914213ab17d8b8e22c2e4212e00f277af2426329b6fbebf"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "84de4c72f6b0d5fe9dc39d8cbdfaad698108c442081ce4acfadcaeae7c6d0ff5"
    sha256                               arm64_monterey: "7bf88699a3f2c2c2780fae4db5ecaf3796dee309a00bf0a1af8336bc5e652a78"
    sha256                               arm64_big_sur:  "07ed9383c21a655e7e112287b6223be03467319518c33cb5dfdf6d05610ec197"
    sha256                               ventura:        "58d53a0d64656e54c2ee6bffe4d424038f0c5de089ea5ea18e5a9338d07ccaaf"
    sha256                               monterey:       "98d64cfce991bfc1ce570af38782ae294e61e021169bb873992d1a780a0eaba9"
    sha256                               big_sur:        "172640b021e6fddad7e68e193a5ecf89f69259ec86d9e91424e1b29d793eeca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9e7c3ffc78f7d06993e24a5c7952b54702796965a14c0a0f2bb89de013f6a5"
  end

  # Match deprecation date of `node@14`.
  # TODO: Remove if migrated to `node@18` or `node`. Update date if migrated to `node@16`.
  # Issue ref: https://github.com/balena-io/balena-cli/issues/2221
  # Issue ref: https://github.com/balena-io/balena-cli/issues/2403
  deprecate! date: "2023-04-30", because: "uses deprecated `node@14`"

  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    system Formula["node@14"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:${PATH}"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end