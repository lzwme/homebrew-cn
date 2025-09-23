class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.8.tgz"
  sha256 "e95dac5d1412833cf720e5052386c4fc463de8826a1da0791fda8fc294f85a04"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "5bc014ea965a5dcfa19a8ec324d107952d9c97022f2b70b41c5123dd6eb9de5a"
    sha256                               arm64_sequoia: "a1fbaec42569d32346997131c32bad71f654cd6f8143a8c2620ed89e35debf35"
    sha256                               arm64_sonoma:  "9805405e3d3f72149c7005bf4a0c143f1d15abc9ef5cab52e54fb3824e788259"
    sha256                               sonoma:        "326133f0fd663040dbbbbbc50e5efcc8e0b31c223bf08e4db509b8445b2c2ad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b8df50a8298bb8ec2aff42c221a4639009c20f95cfa2ea55560f9b62215847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abdeb888e008fe242f55e397b93c7d115f459e18ffa194ea638522c5d01280b6"
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