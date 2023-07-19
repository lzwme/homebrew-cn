require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.1.tgz"
  sha256 "18e7bf5466181b31b0ff252264406008a92aa4b76ed7d0fe4fcee6e2f9cc261b"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "357eb67aea68738cf8be6bcaf9e3484c259d4a1fcf1095229754e72e740dd6fa"
    sha256                               arm64_monterey: "378eda555090d8b761188cbea0e50c6314c86148ccc9c45fadf921d47ceac424"
    sha256                               arm64_big_sur:  "0b930fc46cc296f7b11196088d2a945146b4d08a73e5091468a70a86380e228a"
    sha256                               ventura:        "4496a24961512756391d32cd85dc5f5045b146ce186c0eaf2587c9a9ed686ee1"
    sha256                               monterey:       "45167d983d30dd233b2e268d68a5ffdf4219bb0cde34cc79749dc3ff9b195b31"
    sha256                               big_sur:        "ef1549ec77645123a4c3eb3ea6292db97abd464520835f3204ce64c971fd8afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61f89197e68a2aaafa4d0c2712994e67df2e308721c6f672cbeca666e94fc5d"
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