require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.0.tgz"
  sha256 "2a6065a5c2df681b111a6adf093ccf08be7267d440ca0043792126738333b1b1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "09d01a897a78f4685e904d837122f89c43db7fb755021ca742c837828fd595b3"
    sha256                               arm64_monterey: "2cd5c1678699b678ed686ce9a2457ca48e94bb448f5c783c3f2dce048789032a"
    sha256                               arm64_big_sur:  "fefe1f49cb7cb38caee0c93720055ef191b1296ceb12d593c2779ea53f4e1af6"
    sha256                               ventura:        "efef75ef00b6bcf92ff71d2e13931b749ca65f97b199190689f58d52a44f029f"
    sha256                               monterey:       "fa7bce69883e187e8ee2fb2f8267e3f4b89ac89c094b9099d81c3ae1ae8f02fd"
    sha256                               big_sur:        "3306ec580528098db82104936ba7f4019e16da854e251fb08b08ee55c791731d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8db7c22ea74ab36d4d714ca80d6420c007826a6b3fb35167aa016cdf6319863"
  end

  depends_on "node"

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
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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