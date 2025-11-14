class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.5.1.tgz"
  sha256 "6fc4bd57db3127e7b37b475a189713adfb35536eacedfd343a0b8b18c5d18775"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "d29170819bd9576fe5e0cc0b496ec64867d5c3058658da0d9988f314c9986d72"
    sha256                               arm64_sequoia: "2f8b1618bd71266233256ea7a08cfc365c9efc6a159bf162e5a9ea3eb68d9256"
    sha256                               arm64_sonoma:  "f33de9958e96fc5f6ce2021b0eb6798625a04470d5ae8844ee9414adf97257da"
    sha256                               sonoma:        "884960d30b963222b16caee7d403ddd7d2e6895f8086b906c3eaefdb3ffa089c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab1da1cad171b7452ac7463f429e0a7d465d746a06f9750d9261b1a43105ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c56c54aa372f291fd5904c8f0b66aede3299c67a4a8d562ab017e37a930af6d"
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