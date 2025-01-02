class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.2.1.tgz"
  sha256 "473914195fe4e7eecdf9ea7f33a868ae1a1e59580632fdafb2e5c4e8021afd3e"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "4db1965023d97725c4547625666d22122dd5ba8ffa5f59413bdffb303faf481b"
    sha256                               arm64_sonoma:  "685cc1a3aee451f57e51b5ef0cb88b3ec7e003ac9d2178024bf9ebca6a9bd152"
    sha256                               arm64_ventura: "3369e218f34c7f8503c0a9635d2d250115f10667fa2a6541e380906bc7bbe4e0"
    sha256                               sonoma:        "1031e2aaa978754517fde36324e807b56143fb589e542510f33a62105c970acc"
    sha256                               ventura:       "fc2fae9e206228442d7cd7ef61fb9ed44bfbc7449ad53cd33bea0589b73dadea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f157ccc0a5867b528aab0963ac08edf9a81480ddad57cfe3d264810505091bb"
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