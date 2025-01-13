class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.2.2.tgz"
  sha256 "2bf863021288093031b243bdc06073f9e203b2accc89624054e512521da8bff1"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "5f28ba01b2bb84949deecc8d693f7789383d491a6e44136554b82a17e166de52"
    sha256                               arm64_sonoma:  "6654fca49c00c64973f923ce3abdd69f9e577da7e361bdd8e0fe9c27ed1b051c"
    sha256                               arm64_ventura: "45be0bdaa22b0e409e5a4aea6b94b68dd5ee8bb6c04eff03245ae78cd1a09da1"
    sha256                               sonoma:        "6a99cb65388eab3a79155f7e7b1bf8e45240dd948390ef361dd52b777cb4511b"
    sha256                               ventura:       "44482c83faf670409fd07b214ec95f18403e8247854e6b41bbff12c832a11a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d93d9f0dc501decb9973f20dfb3a39e6b30c2d4238a799797cc41854d12c63"
  end

  # need node@20, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulesbalena-clinode_modules"
    node_modules.glob("{ffi-napi,ref-napi}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules"lzma-nativebuild")
    rm_r(node_modules"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end