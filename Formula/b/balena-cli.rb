class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.3.tgz"
  sha256 "7303cc383c55c850ab94f7fa04855c2f1e071a06ac6a0cb0c5a00a4ac8b52182"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "4bd75e574de96444d7383c3e67c1bfbb8ccd415df60d4f91e4913b549d4971dc"
    sha256                               arm64_sonoma:  "a26cba9b992116104d65fee663af620a42c59b4c721ce4fc05fff8e3eac6f5d4"
    sha256                               arm64_ventura: "b391efea2d2e32e9ea806e11b7156631ca371cbe4b402d504a3e4237af0d429d"
    sha256                               sonoma:        "1359d5e96e4514a3ba6d4e9d35a0a2673d5a31327e4d28418616851eb52b505a"
    sha256                               ventura:       "4ab1a01317b6c4c3a898e0aa839add120b5595229319cbbf101f5665784c518b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78ca2d08d0534939f18fac7eb4683ad624040335a686735631bd20945abf2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f2cf240c05a4d58d9df6b3a79acb980ca92c02a33604733fff44072ba1e1e53"
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