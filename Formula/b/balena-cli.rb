class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.32.tgz"
  sha256 "1ced7da118571b76de631cf84dd9b595d099ae78fff6ff1bd84a0114bc457f54"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1eb555cd6cf8d7cc7bbdb4889548e1d115e3588b59df2ebd9533d63c24bf89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "237160e5931bd2e1121c9b6e3634d96cd41289235e007a49ae41833ae2719a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "237160e5931bd2e1121c9b6e3634d96cd41289235e007a49ae41833ae2719a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eaffedfbcfcdd0b4f496315f79dbc33f704aae1b31b0109009e9a023a98406d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b533512a52d73cebee0f33880d5475a849b64af47e14fcd068c1464072f84bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903892e0162b804ad5d8bfa12c07bab76c66ad947f18ab6d8bed93a291cd7a25"
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