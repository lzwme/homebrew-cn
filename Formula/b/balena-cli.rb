class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.2.7.tgz"
  sha256 "e3b99cb9e08b8f4d6059d5f8ccac3c5235ee00020852b69bfc7e3024a4d79cfa"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "f839f48507dbc4f821ca6aed577da13a59c411febbcd65396820cfda1df79510"
    sha256                               arm64_sonoma:  "cf2899a4b54812607df6711a5037c98771669dccfc0569afa6d8b58eef268ccc"
    sha256                               arm64_ventura: "1da870a13313851e875774dd4d9ca3b3f0b5a0b79c4312403436943500c1b618"
    sha256                               sonoma:        "2306f65cf0f81692cc532f254c378fb2657dac0a07b8f1bd618b857d2db196e6"
    sha256                               ventura:       "8e912558521e65289ebad9742dd25bcccdaf0905e542ebf921c003f63434c3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a35eeff0cedfc65903cff716910953781eb2ae4fec7011f3837b411d4a20a23"
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