class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.4.tgz"
  sha256 "8a0fc2745e6039aa80c71ef8d3844f14f48cecb56aeb754c6383605a0fc093f7"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "1a733cac937838f14b3d9df415e24b9088d0a007c24ea9343265ddad9b9d8668"
    sha256                               arm64_sonoma:  "868bce8861ee8c2f7664ea63524573403674b1b13e0e30e2bda614f01276fcf8"
    sha256                               arm64_ventura: "933ac4b5278fb0d729b78fa3ee5cc1d0522e0f0494dd04ed6700babf4eeeabdf"
    sha256                               sonoma:        "0041f979674effc35fcd3244107235aeb08b7374bcf7e7c4f1e6f18264b72d5f"
    sha256                               ventura:       "5418e7b5504612110824c9240cfaa62d8d0c928909c08cc5c34c4d5da70250cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1e83c8c877a62d31d1c8069cf294426deee77557e170ed7134c0126eeec801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de1295a9b899507137defe9fe923a55b93de71ff2486f78b39ae2196c972963"
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