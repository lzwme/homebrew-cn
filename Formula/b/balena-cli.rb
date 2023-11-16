require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.2.tgz"
  sha256 "cd886cd5fd48efb90b0d87864fcf0322925beaef9dfe312e620966373e648911"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "77bd998f2b2d16e74084af5289c1357898de0b68fd6ff62573116c65efcb3b2e"
    sha256                               arm64_ventura:  "b7f278e66699339d7d33804761fde302f49436c695fc0afcf29b277c8d08400e"
    sha256                               arm64_monterey: "f10577aa2eb771e1c8e5aecb1b07b713f2c88b9d6a4d10de8b401a0d8bcc1f68"
    sha256                               sonoma:         "084bb9dd273d4e5af98c51b6822687e55b4056fd35d761ffbe1d6752e2673596"
    sha256                               ventura:        "abe68f30430615ac7ca42b206a339dafd9564aa31741ffed18b0d7548e0a4d12"
    sha256                               monterey:       "ad2f1c5c776707e5be2b91598d746859eba04f7ddfa83a6171beabbf16ef7e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90bdfd76f59067ac50df9103fa42ccf98fc82b4c3429aa77c158f97fae7841d"
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