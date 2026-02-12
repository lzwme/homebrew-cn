class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.31.tgz"
  sha256 "c9a97db7caa5337386e565ca712bd66957bd50ae8300260cc310b8548b428e39"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9113b0e4c1bf2c76c0e700e9d406ea8d0363010f1462d9a5a1710af843e663f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c8db00ecd57617431959e111628f73e27815a019fded24e4273a7ca352b8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c8db00ecd57617431959e111628f73e27815a019fded24e4273a7ca352b8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d5ed3346e9609a0fd97d28390f56ccbb72f4c668d353d27491a92ecfc800d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e820bf74a6ab1599ffda4dae97d451ae8c795f4ccca63637f4d968370678bf24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e2b856043f06a4df82c0b9a0545e97ddcf74a485bb122ad9274a07bb61b191"
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