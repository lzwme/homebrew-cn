class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.6.tgz"
  sha256 "8435edf80f6b135501aa6836d6c70d55993adfd4f93ccc26325f80d37ed0ea8c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45008a12f9a35f0c397da94bc30f12f69bd3ad90764b694fae6fe7292c1c636e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79ddc317ab30ea3847fe90c10b8c756d111aa0f2c013e5ad57aab7c3c0f16ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79ddc317ab30ea3847fe90c10b8c756d111aa0f2c013e5ad57aab7c3c0f16ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1716c75661676fa81a71fbd0bb522ab8f6f915691ae542cfb1ddfa7e9f577ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab98e5e6ca722c0fb05bafb6bfac4ce04ad8f07c5f877fa678deab6616900fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f807d479c4694d7214cff1578d4ef68f3ba165e790301751b73e54896e66e9"
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