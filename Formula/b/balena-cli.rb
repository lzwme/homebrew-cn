class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.22.tgz"
  sha256 "57f02dba314a5d23b29c274b42112a7b327181c86cddff014ab7188aa51cd437"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0129a693acacc05afc055b6713d8a35d2f917029e61ef03b2a1a7b4c77e1656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cffa68cadc5837605d171d1dcb7a2c8e0eb56a4a011921ebbba3e43991c8f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cffa68cadc5837605d171d1dcb7a2c8e0eb56a4a011921ebbba3e43991c8f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ccdab2d9bc422c2acc6174c6c4dc92158f33642c5ed116b3f8b0a1832a3a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51633e0909994bc49ef0a34a4349135a1182ca8e48452f172f7e915691750547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2d4caaafc71c00d30a74f0fc3ca8a70338bb22c195070786726f8016670ad1"
  end

  depends_on "node"

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

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end