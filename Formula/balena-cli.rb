require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.6.tgz"
  sha256 "97c9f93aa7e96e3ae1365f8bab7ff6c314eb64a513cd59fc5a4f0bfee4e072fc"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "2049d275623c7d43c6bfa6273785c202a070ba782ce20259376f0216f9bde1a6"
    sha256                               arm64_monterey: "3772d90f8dd27a70e8fd3b4d87bc926dff5f9cd681a7dfcb576ff855104d1044"
    sha256                               arm64_big_sur:  "3d6d8a966bc9e8dea4dc131360373ed7a399034cf5f608daa4ba6da4c0883bec"
    sha256                               ventura:        "1376ea9b551488bc461e425351f0c67ab9b385319809d0ff9210b33b5a0b2623"
    sha256                               monterey:       "6939ed0d0926781354c5d3876487adac168201c4ba9361752386e5858ef1b3d6"
    sha256                               big_sur:        "d05e7e73496f8063abf3fd596a4d413e553b56751c7a9376b3f1c4dae5b44ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5fb329b4ed11d3d885a088b7ac28e421e87294653e9a81b4bc691aa4182601"
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