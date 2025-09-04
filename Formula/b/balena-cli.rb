class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.1.tgz"
  sha256 "09e6882f83ec0854a84239111ebeacdc023787ce78170e58dbb219e541a8fbf4"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "0374e073906aeef81d86d70568d1b0d507e862c10618ecce5bbf1d7d33da7089"
    sha256                               arm64_sonoma:  "c836112d672096ea26b900cb3f5382092cc16b62b24e1ffa145ee77e7f48314b"
    sha256                               arm64_ventura: "715d8242bb069a9991d99a6b397f232f550a80e4b54b97349c17747ae721ed0f"
    sha256                               sonoma:        "efd52ff7f237ac34bf765ec431eba5fe1c32515409be936aa525cb11763649d4"
    sha256                               ventura:       "b23db683f70531bfd8a5619e0f9013c401fde8acb2b94f90320c5dedf76393c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e75a537ea626a650c700b288b6113d478a08422bb1a5fa5596335de72c89da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874ce23a7c2b3ab42117f9de54b1057568d91b8374eec6cd797bf83a7ee0736e"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end