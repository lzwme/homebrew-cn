class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.2.tgz"
  sha256 "188d4b31bc0623d70b6b123b2fcb824b83db062e1aa8468dba376f7100554f4e"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "858f7cb79d02312f37e2d71cd4091e8e6aab75e832187e3c2717c30df240fbc6"
    sha256                               arm64_sonoma:  "c371b3a18165c31455c1f021431effb07b6bc72fc783cb2f0e7900d012af3f35"
    sha256                               arm64_ventura: "3b9747e48c740249fc6fa02d1a98696ec000b553f5913b97a564bab6145ce6a2"
    sha256                               sonoma:        "159aa0c20a8ec116d55a49f9d1316a0f942ffd0c1027bc75fceae41c27479c01"
    sha256                               ventura:       "b20206f526c8682dfd729338ec42c98e25278841b1f0ba084f6b1840f1cca9aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4bd5f0da689d3eab750ba20ee61419064d9e58d2a87f5c8268ed5b5e503cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd84c7137fba18bbfab0444a49fe2486e989002e26229e6278923aebd04afb04"
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