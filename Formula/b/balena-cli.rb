class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.9.tgz"
  sha256 "04071955981b2c15155a4d1957e12cf56a3e643f91c179ce0fa974efa2ad656e"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia:  "55d1f9b85a0063f8ee0e40982f0ad02ce24485ee9362761e0392d9f3bf6f43f6"
    sha256                               arm64_sonoma:   "7510fb066669f0b809a36a754d40897fc61a6396505f42014d011c967bb31d06"
    sha256                               arm64_ventura:  "f66fcda718973a03222fd13fda337c24b2ea0031169a1fb2ec94840f15ff4fc9"
    sha256                               arm64_monterey: "2bac009c70da044e5e9f50b07e725d56be37b0a72a9b5e807328d1dd6276b06e"
    sha256                               sonoma:         "0e0324eb1bb82f0efbd2fce324f4bd3817681849ccba926ba52bf02033fddd51"
    sha256                               ventura:        "541a5ba671255905e5066273f1e7cb3f2ddbc3c386d5df3bbdd9040991060dcf"
    sha256                               monterey:       "08de218d1653e9043f72f77a6f433d181cb6b43ec0dfce5707873cc6bf1f0c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8756ef15712996a796ed2fc521c3b57c956e621ecc9bba8c3206bd6299b8e05d"
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