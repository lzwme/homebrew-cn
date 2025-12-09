class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.8.tgz"
  sha256 "7d0e6b7209cb0c88754df397c14fa9e7e742687fcb7ed406c6c7710a278a6862"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d5d6aefbff0f0394a5cde3c3afee72acf4dfcc43242c2beda7cebc830915e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc110aa9b8ced9530ad882f74fe4508c9e47ff5d7979f3ef93365ea34bd58635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc110aa9b8ced9530ad882f74fe4508c9e47ff5d7979f3ef93365ea34bd58635"
    sha256 cellar: :any_skip_relocation, sonoma:        "199c5a9bd3adf736e543d1a3c0c3739306287066216ff73b97a9e03c69e2d77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f82db8b43cdd18b679b6560638a95842afbb766b5d0c9d9f7c1222ccb3e04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e6029d29f07a12b16e5ae686d3b1c07784b434612366603c6888a3dd652992"
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

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end