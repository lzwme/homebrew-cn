class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.0.tgz"
  sha256 "5dc536aa47514bed0186fc92697ecfffd7519411f7cd6615c0bcb4978e8188e1"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "03274c66c4cb8b14af68c42ad1c7301462f7c9193f4485f563917b6d52cffa50"
    sha256                               arm64_sonoma:  "d2e9ef2f44c96967bd298d793bb64fc402206869a9a47332bb551427e3a5fce0"
    sha256                               arm64_ventura: "824059243e801dc35cc386632e683c4004526f676f0d15a33236b6fd33ab991b"
    sha256                               sonoma:        "302fa20ec6da65e5cda6e641ffca5a6fcb4d7739af2abba7f4c5ffdc28ac1f01"
    sha256                               ventura:       "a08198cd42e034f75b6b3d80501c424376ada0f0df97e59b3617c0daef826bf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4926d9cf07eabf425e0da89d8adb6719e2468eb61625c1629940b89f6c44efbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1057ef5b5eadccaae4076743dfb5907c7efc91a86aa57a4cc6c633e265774f"
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