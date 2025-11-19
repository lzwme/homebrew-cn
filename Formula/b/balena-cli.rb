class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.1.tgz"
  sha256 "5d2bec2de3bd6666039d5d78dd442178d4a0225d24651a6842e9fa5e87f43ee8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "84e28e4268f2a668373314242edc88b347a35ac1d6df9047427e4eeee2edaafa"
    sha256                               arm64_sequoia: "131158212653028cf5bb8cb7d141c105a9123fbb586a9f66d52300f190679096"
    sha256                               arm64_sonoma:  "adbe9040472888f64726110692316b2390ac1ecccdc7a75e82c583f658477860"
    sha256                               sonoma:        "f3e64cdb23fd31e08b23b27c2c3fbefebd3c5b572d67004217327b5488293bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7796cd76cf3a28334b8ed89c767a254f5e8b655f4112a32f1bf8da38d7f7665b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa25d583bb2504c2437519cd1924afb142cf820791f9f0b39359b388ee7b0af5"
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