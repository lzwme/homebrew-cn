class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.0.tgz"
  sha256 "89cc76dfde8c19e0c50f13cda4ed876bc17ef9445ffcc22b4d7408cfbc23ab14"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "6c7424cc7d5e6192457f22b2b61e01c41e634847e375cb938e5b5bfb384a9cad"
    sha256                               arm64_sonoma:  "c222f04265e711e73c4a4bf85db13e7046bbeccb9f346ad4230c66a2df18bdd9"
    sha256                               arm64_ventura: "c7648a69250fe201629e441e7779177447f1907087bb97a733881f24a95b78ad"
    sha256                               sonoma:        "22a061f05a2d1352145b405556d3dec683012a08187bd0b09016e26d76d5cfce"
    sha256                               ventura:       "cf0fa11ccf49d6d0f03c916a2f14c1e181018124aa48f9e9b549bc0c02bce1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82e00507977a29c8f1d33ad126130e9507dbd1a367c95e3e88cc027411cab7"
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