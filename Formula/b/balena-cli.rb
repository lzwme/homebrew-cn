class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.14.0.tgz"
  sha256 "fd4b3bbf254db257147908c436acc6e153048991850e76bc9de754430bde46ff"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "5192936c9c1c3336c42cd154b6662ab1377b6061b9f2d318307c2ab96081a6ec"
    sha256                               arm64_sonoma:  "e964f002ec9df5a59bdc0df480e5fa2e565780d8cacade01ec04afa9e0ed0447"
    sha256                               arm64_ventura: "4271b748de7886b3af1a02163918bbb5a949b02d552c8730d4c727b3ac14bc43"
    sha256                               sonoma:        "cb15f358b9c9f7d1a8e03a505fd3e30ef0e3969910681d779b49b33c1885af39"
    sha256                               ventura:       "ddcd66c83bdd541e36a628253368c7d74e5b4fb7ea6dcd0e88335fbd00a59fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788bf872fe72ff2edf12beabdfe8a509d6ead97b192353f4a76c586b4f949926"
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