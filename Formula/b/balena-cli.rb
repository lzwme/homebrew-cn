class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.5.0.tgz"
  sha256 "c973e20c81192e9c68844d616b26303cece022053665d611d8261daf64469944"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "9459228ad960a51075c4e36c6fc9564cc130a7e055c4304c8441bbea05de1503"
    sha256                               arm64_sonoma:  "df9dbaba19800c8c381c3c5a5a713945d1e55b05449b707168360c305c8bd7de"
    sha256                               arm64_ventura: "97bf4ef8d8f76462ba07fec9ba72918942276d5023fc68de9bb5aa5d0dd07816"
    sha256                               sonoma:        "ef937c3668918a7f74bc8577acd2b8b704491f7b5073f5d1e9e92eaf8a81a9fb"
    sha256                               ventura:       "16852844b9c8459fdf3c81e4ed137aa508d6dcdad15073287216187ebe76afdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a60115b8f02212af4ee327b27292ae0c00edacaa0f41e37794cf1e2b9424122"
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