require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.0.4.tgz"
  sha256 "6d2c69e797f0dbd90b45822838e69f5604e5675bc6e134d28afc03f19ca77761"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "9467087a9da09ed6bbede80b92de12f4ed83f8c7620005c682bc381e434769c2"
    sha256                               arm64_ventura:  "06561766a645b7b5d42e541d377039ddc917d3a92ae9cf08cef04ffe1749824f"
    sha256                               arm64_monterey: "5cfe2f2bb027b4763143e7cadab53f9294bf536ed9d5722beda0fe7faf3c3c04"
    sha256                               sonoma:         "f0305d463361c5c3ab09b442b0964b85e1da9a495789255bd90924dcc73b06ef"
    sha256                               ventura:        "cfa582e5d2e9d7221bd9ceb7c28614f15b8a3372330b54e6451ef43d28a49c92"
    sha256                               monterey:       "04c9b8559a861dc64d8ce1ca6505c69c0b4c5e35c0676f433e2fdd38db93a0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9de0258599b4e6ce876de7e7ae41c55f50a4c6f461b7c0975825d2b5c0812b"
  end

  # need node@18, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@18"

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
    ENV.prepend_path "PATH", Formula["node@18"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end