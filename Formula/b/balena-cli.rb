class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.6.tgz"
  sha256 "212c90deede4daa94108a6f56a369280be78693acfcaeff6bbec57580ac51b37"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "59b87e31e1579676c1d0855407818ec470c2190744a4541ad68e91904ccff1e5"
    sha256                               arm64_sonoma:  "2b5ffd2e8c1584c69e04a44a89194bb2b3c9be933934416d129f90dc2f1f994b"
    sha256                               arm64_ventura: "c5c04a582709119341b35050d33160ac8807d8e8d08bb734b49236b24391c9bc"
    sha256                               sonoma:        "833f92cb088f459ea9c3f551ed9636b89810492443d854bc89d451850b180c93"
    sha256                               ventura:       "66e672c72377cbb4c68164c6c0ebe9bcb44b0b30b1a02a3bb9df22d49162345d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c372731c6fde0e8cf75c6ac161cd574264b8ae3c96dab79df02956e26e5a10"
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