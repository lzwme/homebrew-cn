class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.5.0.tgz"
  sha256 "b24b7879b6b5d0283c70e36fb5ea2bd2b1a0d9a8c7356f17952ae022a73c6a27"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "3dbcf3bd529ca940b239a0ec56191d6fdaafd89a72a64b1bc08d12c130b79d01"
    sha256                               arm64_sequoia: "7279f8ac052362eaeee3b256aa85e3678a3f1d9302ac5e4bda755347558417d3"
    sha256                               arm64_sonoma:  "6ecb85121063d89b6e8cd5909c9419184d089a97f8be64a4dafc221b19958457"
    sha256                               sonoma:        "3b9cf1add0b243a64529d4d92a7c7f1c094ba58c5a18aef24c415600347d9d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c36825e8dd76d423f91e100945866c17256b09a7891fd96d9e57ec66d630189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fa2a1fcc5da8f279a4c68d164c3b37971aa750999f0455209754861cbd4a35"
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