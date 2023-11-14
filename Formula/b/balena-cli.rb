require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.1.tgz"
  sha256 "5adfe5920fe1c9e1665f338329bfb6d593530cbf073b8fa21311de4fec0adec0"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "2bd1d479c408f3ef94a22529f5f880a9f572d65f312bd2b29fc763fcff6af833"
    sha256                               arm64_ventura:  "7c4ea2ce24cd029771f2fc81cfbf70de142b688ff541088f2110411ac9761140"
    sha256                               arm64_monterey: "ae4e09328cebe3afab315547091fb70c38b984c59113ddb0fb290faeb5d48d4a"
    sha256                               sonoma:         "44b1c7d2b93fb6064e9283356ebaa2c3301a3e968bac7fe95bc2a911a0d8e3c5"
    sha256                               ventura:        "836f914227b7c4f942828596ba0cf1da83b490f5b3f005975a8863f464892b31"
    sha256                               monterey:       "34d31254a3955f5a4303fd318090644e7e4b3bc1762e61e236e1dd607bdc4e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1f18e2ce922a3b075bc5c95ff0ec88148181937e3e38027f4430e4f85114385"
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

    # Remove `oclif` patch, it is a devDependency, see discussions in https://github.com/balena-io/balena-cli/issues/2675
    rm "patches/all/oclif+3.17.2.patch"

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