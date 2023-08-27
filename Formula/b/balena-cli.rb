require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.8.0.tgz"
  sha256 "d6ea08e78597f98f8076410d5e0c36464e80954785e9bdacf1b04d9411b20a52"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "3240307148c4495a08d703249aa233204d7706a0ff87f756acb4550dc11b2e10"
    sha256                               arm64_monterey: "673c287f15fa6330b7cb8876322c5c5ce759fe4b82006b0790506c05776c564d"
    sha256                               arm64_big_sur:  "2866e7d49c5fd3d6ecc2d2b956a6f063398b6145f067e4b88d95a94f617eb2b9"
    sha256                               ventura:        "11a085a50b54b18d5a22259dd7e89b8a31bf52770aaa44971408fdd7a39f99d5"
    sha256                               monterey:       "e9868b34c75e0c5ef84ee6ca8bc05d2f5becdfc43c84095b2023e91a24de10ee"
    sha256                               big_sur:        "c3d0a1092e4d5e3f3e65693719e871923f71cd04e45717bf2a5ad2dd190bea4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c57520b1ff2ab2ec84d5248b3ceabbaf7d05f49cb6470adb1184fdfbf7626bd"
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