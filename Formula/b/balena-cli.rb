class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.13.tgz"
  sha256 "ef2a0300605ecf4ee589001416475dfc3c41207200fbf39d49c9d294485ba5f1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33803e0f857d8649a6a9b59b5121553f012e1d2c1db103710b90cf0ecb6313a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab78623baabc797ae3686f4037ffa93f23bc6ccbfc00c855b743e4a8850c5eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab78623baabc797ae3686f4037ffa93f23bc6ccbfc00c855b743e4a8850c5eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09071517ece65bace304a23a81c1dabd6fc98a87f966e4a5ec1948f3529a492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc811ddd2996afda091f24274fe69372a0e4b025fc1005fad7a6ba719e5ebc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6a7690c27532f67255c51331b5535684b3a8635c6915c26e8f880ab0dcd400"
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