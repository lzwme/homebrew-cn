class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.5.tgz"
  sha256 "5780f7f2ada1852854a937127ceff1d9cac5dcf7a047fdd37d1eee298833b181"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "72ce16b63ae8bc836d5a75f65d898c49af5dd2644df7eb88e3671eced73957a8"
    sha256                               arm64_ventura:  "70455190c5c658c1bb33f48cc40e8ce82ac2fe1631de108105c426f732746201"
    sha256                               arm64_monterey: "49cca5e740ff08dc473b97a5417750a25b8093880e94d07bbe2d4224c4822bc9"
    sha256                               sonoma:         "f3f82b1bb1c731235fc68d39d8f7def1e8b56e1dd4e1c912c8814212d80ac671"
    sha256                               ventura:        "2bc6417ffd9a35ce261d58233283aa1b6771502ea0ae5279e978f310ecdfb625"
    sha256                               monterey:       "893c3f83f0d32a33ce618dfb52b51550792f6efe1c2240d0dc606d8c6e802f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be97c6abf5cb86b51bb4a74e7dea22aee2ed35a75577f823e3abcece8861c005"
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