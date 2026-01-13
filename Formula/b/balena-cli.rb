class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.17.tgz"
  sha256 "14282a99d4551e520f58f8c64d737fcf0e64d78762a0f463abed8b3c7ec72c84"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99fe14169bbbe5bc53ede44d979d2c870512138f89b0f3937b6bde65c84ae232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4765e2d0e18f4215a4c1542a239fb0440043b83e998536cc63ae2401d867642a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4765e2d0e18f4215a4c1542a239fb0440043b83e998536cc63ae2401d867642a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ba000da93e3dc54d178e4f052e2bd376ac549e21c98a2434e6e06626fa7a08e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56117ecbab44b7fe35bc0b6f09837ce2f6a463179c674f4706991bdba1ad716e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104682eabfb3ed680536d04292a5a15450668920e36df01d2e58b473d69c5259"
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