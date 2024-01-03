require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-17.4.10.tgz"
  sha256 "128a0e49b5c0acec885084d7fbbaf7f17fc7f5834586b611ea3f56cc7f1744a7"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "055ab5e1cbee21c83f24a40dd1098d59c06bb180b43083550971b7f0faad6d09"
    sha256                               arm64_ventura:  "9a10dafec493d22d53ebddea082edc878b0484543ecedef8336517dbc1e655a2"
    sha256                               arm64_monterey: "a358e026d637f3cbd9c3986bae866f175fe7c7584c9f2e0436c8318404ed8a66"
    sha256                               sonoma:         "212cb6d33cde4176c88aac2aa3101bd2f176819745613b344b8710649246e4a2"
    sha256                               ventura:        "9b7ca1c6cffd41991cb184c6b3803d3736b1b91120f0331dc927c3bd71e2ac13"
    sha256                               monterey:       "5299901fb2bcb91ea1ab787c459dd657420155216b7f1b590773674eb32f5c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5564d884517135ff3e6cab25204292c337c7f54916e7b0181a312ef1faa8aee"
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

    # Remove `oclif` patch, it is a devDependency, see discussions in https:github.combalena-iobalena-cliissues2675
    rm "patchesalloclif+3.17.2.patch"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulesbalena-clinode_modules"
    node_modules.glob("{ffi-napi,ref-napi}prebuilds*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules"lzma-nativebuild").rmtree
    (node_modules"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules"term-sizevendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modulesmod"bin"mod).unlink
          system "make", "-C", node_modulesmod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end