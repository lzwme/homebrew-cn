class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.5.tgz"
  sha256 "e615cb647ba17ba077646e2baf353afe1bf5eb06e34bf2d49b6efb51aec5a2c3"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "67d6366081268f999978582e35649e3e2d877f4af4081acdcc5c3182dade45c6"
    sha256                               arm64_sonoma:  "5f7792bf40771cb027e71b1ba585dfed7217a25296bbc2f4f937a1418af62de8"
    sha256                               arm64_ventura: "9494cb739b768ee43a356dae378a8f5df1ee0d7591e4f82a16888f42badec126"
    sha256                               sonoma:        "665e376813a567f3a964154dd22e981d11525fd13a0b6845fc92d66b75bc18fc"
    sha256                               ventura:       "464e68103724c3950c9106a2603a859bf75ac2c4cda113335387c603ad7c70a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f866853fe334e4ab755d6d55ca6f4e7574f0fce43393aeafbbac521b4c9d13f"
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