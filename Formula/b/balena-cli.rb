class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.2.tgz"
  sha256 "94cafe8aaaba098c093e5e61e1fb913cf105e60f96da1617f4cbd43cab65c0b3"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "3a26ca4efe9621ec0964f5f88d48978ad8f1997098432add2a29e63badf9af24"
    sha256                               arm64_ventura:  "b07dc9666b2180a5bb24540b31e7f1960fb966f158858e73b5fe2b3672bf77fc"
    sha256                               arm64_monterey: "d3eaf444e0ad3a065384cf47fed75f35791451e67e206ffde41b2be851922589"
    sha256                               sonoma:         "e7a95a4fc7542159001ae54b97bcf2468edf6dff67b8a26c4508100ddc5fe208"
    sha256                               ventura:        "a699c90f620b6318425ef2e84e8b5b4881e39f5511851d6599dd27d777d45b22"
    sha256                               monterey:       "0524c14db5f915241796ee367e04fc2abd191af54c0d22074ccccf15f832807d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511250f2622f8ee87b2e9bb794b8f1b88c76c1a8d56afc1c3dfd465a9eef1eb5"
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