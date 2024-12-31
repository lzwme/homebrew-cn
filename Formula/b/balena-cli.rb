class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.1.6.tgz"
  sha256 "7a953cec011b69456e5239358e99c805b5407349115902b9326585ce25c79b0c"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "9e837e652d7d02103ba0fbfc1b518f28ac4c36572415e36de6ce177e4d812f4b"
    sha256                               arm64_sonoma:  "c56164e92730cfb0b94838e4e0770c1133c422757d4c3d2684e5d2e0e08fe5e2"
    sha256                               arm64_ventura: "8e3024841d2b078ed8d98dcdfad1ea19f2140c3f3ef1575439dc3b1aae7569d2"
    sha256                               sonoma:        "78918d9a755dc2920808dc469fed0a3324c8b96ae90ea38db0fa1e7ab24dc9c1"
    sha256                               ventura:       "118a49644441e9eef94e8305c8f814715503ec117a4d9bcbcce60544b42a7ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bef879a170e585fa284d6043b07c0de5ca368ea24b4e471c66f0e757c7b9ca"
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