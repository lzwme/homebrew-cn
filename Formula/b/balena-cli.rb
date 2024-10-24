class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.16.0.tgz"
  sha256 "726498df2b8835dbcd80e20b301c8c189780d16fe29a90ff8af7fc159bbb296b"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "b7105acc7395b3b5cc7cac93c35e03c10ee99b5e5013600be5f8eae36cc3a083"
    sha256                               arm64_sonoma:  "335be4f5d64f659d534799711b0c2b5dedc4096c8a50ab9d51bbde7ba37198b7"
    sha256                               arm64_ventura: "0ca0c4e72ad57dff75c4e0bfcc82a12505503a95f7f670f5f34dbfaa5ddba708"
    sha256                               sonoma:        "b441511209d2d55d437e1f0326cd158c19ca1cf0b6f990627fb3517178948434"
    sha256                               ventura:       "3487b72ce9040697287ab02f0102ef96ae3a91847d5cd831490e00271c7a19eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5618489b3db6dfdf00d37da4a229701804a2c09b338571a623165c34e4c930"
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