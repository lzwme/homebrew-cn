class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.1.3.tgz"
  sha256 "b0bf59f0c4d2ccd7b3743683ab13a09cc60d81a42995a25a8662173424282447"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "4fb7156b64cef53e783cd67810f7a8d3cc0492f8a7219bf16f3ec90444b0ceb0"
    sha256                               arm64_sequoia: "7975fde23142b03978d20ae25a84a0d15afae0b43883d6645c9fc180aba88be3"
    sha256                               arm64_sonoma:  "48edbcbd7dbfd7e4aad9275d8b0cce65027d203a252f1cddeb61b99d2ce7e25f"
    sha256                               sonoma:        "3d554776ba1c9267361a5bf2384dd4d55d77ff216ebbfacb95ed1487f4de283f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a7b15fde278e0ac8c9fbfebda7f17c6fe4bb4f8ab1926e09014d5f71320ebad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796ba9a9ac69e313a3d6e0bb42860851a4c331673e84c99b6daebfe0d133fbbd"
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