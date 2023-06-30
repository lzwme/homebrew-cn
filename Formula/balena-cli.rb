require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.2.tgz"
  sha256 "9f3e04733775bcab07df18bb258fec8fac3e558cb501d245c3810399420132f8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "49384675e56ae5494fa2e42620b19759381e5ed7c9f90f15c9b0ee3054747d9e"
    sha256                               arm64_monterey: "bfbe6c03bab9f78cfc1a5699c28d3ffddd4567e90acc27b81fb19e061ccdb545"
    sha256                               arm64_big_sur:  "cc3a896c89bb38dda1cc172843809fb45986fdce642b05fa632d596f633e0ae8"
    sha256                               ventura:        "fb337d78018b24f4864d301fee853201c559ee10e84bb05e0a0bda3408c5bc82"
    sha256                               monterey:       "26651e44d6c9330fdcc9dedda84b4918b791bda5b93c308181f8baa6f7fd6c5e"
    sha256                               big_sur:        "e5d8c3738cb7fe8ed9add76a5e8b7554595b5dceb4bb70525d284ffbd728d820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1389e1e01b961a5915afa3f6cba34565ffa2ef45e256f5ba2991fb93ad917c2e"
  end

  depends_on "node@16"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize
    system Formula["node@16"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@16"].opt_bin}:${PATH}"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

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