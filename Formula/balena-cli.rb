require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.2.tgz"
  sha256 "8c88994a8380c3eb6884f3c8d838976b9018ac6afe928d6e84e979be7a5641f7"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "563483b8695b2a287b56880249f16e1b488faee23181bd054ef2c0f3a11d63bc"
    sha256                               arm64_monterey: "9ede34d2f9354ed0e22657aeabc265c8536c4e258f72e65af4e5b8451505dbf4"
    sha256                               arm64_big_sur:  "0ffcdd4a0f58abbc13832772e7c043951ab54f6732f195487d3df8525f14c789"
    sha256                               ventura:        "17f95502d18d569e38839f6cc424f5b44c6b7820103e7b91f31a986f67396234"
    sha256                               monterey:       "47a6b48fbd52f37d535113b3de4cdc57e68dfb16d3c0fd10ebb7d63b3e67233a"
    sha256                               big_sur:        "a122bfbd19cc8819b6650afb19512652265b563edcc97bce71ca0e9cc538eb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9da070167451e1638f894a2d19e6e9e53619d8a98a4ac32711f5160c9468f1e"
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