require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-15.1.2.tgz"
  sha256 "5be07ad6a9ee46d4ab43bfcbaedab9a6c809dd5f6de6afb1634ca29601189cf8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "8cb9755036d3d41db280be6b1f62e8077b116d10720946fc96a74f09ff4cd729"
    sha256                               arm64_monterey: "aafdb502089d6a84dbbd6871f8f1af8e6324dfc16ffe7aad89dc156688285518"
    sha256                               arm64_big_sur:  "ec3240dcc4390263c9202938f6fa47257bef89faa1f8c7488e9bec6992ffe9f4"
    sha256                               ventura:        "849d8c9a0065659172c4294fecf869b6ccba1bce1274a77b4a489de5890f66b6"
    sha256                               monterey:       "5d0237b10255fdcfe4079ff98e9cf6284a2d744dd076a4f66b7f24621040aaaa"
    sha256                               big_sur:        "a06e72265ebbb7145998389c12c76bee121c5f84d2ea5c5f6e6a41a6bd790a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb71109af087be773c52f3c0247f2f779e79dcf47e6dbf1c87e9b79b576943be"
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