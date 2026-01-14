class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.20.tgz"
  sha256 "93223ca71a151eb80eb70a75480c14a0db281649af8c0a957cc4a9cd1a2e2083"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc18fb353a2ea9a793ae3e73f4e3e5413d60549da265ff4dd0b64dd74ec1dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65bd0c220386f084cfc39049430b049920e5a416ac07c6174ecd6b51fcddabc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65bd0c220386f084cfc39049430b049920e5a416ac07c6174ecd6b51fcddabc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd0656ae250ebab23bd781489c8a2e45f2bef32160df3b53c9868ef19f1d3139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6103c4c168aee024fdc3c5cb922af825e8bd816bccd2062a44263ad9845d948d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c625dc6811b54e3e2442e576fb9440cb2737164d2b38222befbda42a5ed03f1"
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