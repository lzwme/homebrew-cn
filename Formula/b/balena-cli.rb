class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.1.tgz"
  sha256 "98d00b32da73b8a84da74245de96e429060b279d7cd876a9c27f07651be577a6"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "c6b74dd3a7cab1b758c02565c399e89b059f48f1fe10be4411001431f9367c34"
    sha256                               arm64_sonoma:  "207eaa17c9f9e4547a52417a6a5463ba7089e1fbee7c2860c9b82fb6189e6783"
    sha256                               arm64_ventura: "1fda874faab52f769935292e90fe1f225d1987c9af603162e2837d5adb4dbd0b"
    sha256                               sonoma:        "f0e5b8f8d43193d054012fa67696e606819c17a59e538789d734015d76fdf7d2"
    sha256                               ventura:       "b8b7449b749085e23fc4f1f4fe07f134c41e98cd4d44893dbeef0473fcddf980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dffdcddb96fc154625478522cacb659f7c174b29e13da19e7c323961dca8d999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ddca6844c1fb7fe1cb7c1c66187b7bc97fcb7a6650a2f2a7e57da3c188d274"
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