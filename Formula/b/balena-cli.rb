class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.3.tgz"
  sha256 "7b6ada5f4a1077391dadd655e7f2c36827ebccadb75712b8b53e5982d02bba5c"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f6003656ab2c7c080954f649fec16207336e5098dd5479e1624ab24cead57d1a"
    sha256                               arm64_ventura:  "2e5bab742afe051672b66dfbb7a9267a1c0e941266456b87a3087c01e6c3d15d"
    sha256                               arm64_monterey: "d738052d7f66c07baa694b2baf46412664db8917ebb9ca3656bbe99a35d7bda2"
    sha256                               sonoma:         "b9c7488635af0ab3eb22b47bb5aada0bc1ff38e77f354629ce90ce6c9dfbd126"
    sha256                               ventura:        "a9ff4db59f2845969a2953e9accf48ad2eb97549862cee455066baf1fb91b636"
    sha256                               monterey:       "2a64ae5d314ecf28435499e8c320271bdcaf6e906e7ae0b0af78a28d9fa3e3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0975e78b2f60dba2a5ab191162c368e8bda3a42516c21a22d83c10b0f0aeb52"
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