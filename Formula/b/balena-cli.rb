require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.6.tgz"
  sha256 "5e8005641bdb358898f5f3a672c95dc7ee199a7a21017980badf826b2b49b0b4"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4026d12fd734f3d61a0048c3bea95ea80de0226cd2bc810830e56950bc5aad7a"
    sha256                               arm64_ventura:  "9a96be28a57d1f82d0d257fd05c33a8768c255d459645d9408a0157797758de3"
    sha256                               arm64_monterey: "74483d8e7b209f0b671f860415980d9e23ad565004b9975503da804fd00635a8"
    sha256                               sonoma:         "71e0c53d17d49bbc8b8de0d06561df9832d4a6151d9295826e2745abfac13b00"
    sha256                               ventura:        "6d29ba3dd125502e6e4618638eb275b0a0b2d07e054f3e6f0a916f7ddd250a09"
    sha256                               monterey:       "97f66c81e129dd38fbea8ecac38d5ca58a71514c8cfd327589f07a65cd1daba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9477b66da7f66bb66ff7ffa92a52dc446c39b1eff99e6965376c7cf06afc8648"
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