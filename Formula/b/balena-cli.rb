class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.11.tgz"
  sha256 "2b9833da96c6b02bd9909d966b833347463803d615521fbdd62bd3e99a605cef"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f74978b45b991932a442de008013214d34dd0403ee538f7aa13671e492589d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1102d4ac81ea9687ade0c1b7dca0b53a5f16d783329610a483b54120e2abc06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1102d4ac81ea9687ade0c1b7dca0b53a5f16d783329610a483b54120e2abc06"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdd6c3f969a61914756a11c1c96e177d8b711cbf314029f3bae673f43794c641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7aeea556dba4f1e13d68e22ab5a1ac4e99dcd96414df91aeb39dd1f220d850f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b95cf06a6e9dabdd9ccd717c1503703249918f99a14d209152201009f17a23"
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