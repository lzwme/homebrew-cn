class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.10.tgz"
  sha256 "6a774e1964b1047ebff06741807ed21678d2cec70e025706e2e194614cc0c03c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d182f355757a75e6e1956934a6ff56c8dcc805d91332e7d3ba832e2355027e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e069064399d52dc016036d1bb9e897bfe21d6b4e6a59efeccba2145f7a26d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e069064399d52dc016036d1bb9e897bfe21d6b4e6a59efeccba2145f7a26d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "f959341083d206cedfdab59834f5a7ce509636436c0e640da793fdd5385598a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d32608d10f4a842fdec264e6f23ef89e604e1b983aa2391c4e387aad942d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c4f87f1ed7e6cad4bedaf5845e627015ee707a25c9260862fb9bbd41dde620"
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