class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.4.0.tgz"
  sha256 "ba7ce8968bf1235525e58e72b031e91171236dd6e03d86b0ddce2368bdbe3c9f"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "1b8db5a007c067f0e2177a6968a068ffaa382ce42db2c3a6e9ca0132353dbe98"
    sha256                               arm64_sonoma:  "db856e0ba86017a107a71335bf5ea9bdf66c9f0690c209f9edca425deb7e4a6c"
    sha256                               arm64_ventura: "deb6983ca94b38440231429a44f6e18fcbf793334ea318ba0165427c568b3635"
    sha256                               sonoma:        "1117a572c5b2adbd8f9dc26789ebe6acb5954b6a3ecc4864309ff093f42b3c32"
    sha256                               ventura:       "b2ba1ce241914ec9e4a7918962aa91b298127afde05d1fd5d3591f640fae2bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330141936333f1a1aa8b4eeeffba5f01e68e13d817ce8478e3f01de95cfcd083"
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