class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.17.tgz"
  sha256 "f2ad7615b3585970e8f5e899cf19f14f7b615694c5aa60a59046fceab895768b"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "eec19018a7bba2ab1dfc8c651df34a4834aed36aa286ffd4d15b374d2bfb24c7"
    sha256                               arm64_sequoia: "9f1e0c490de93ef0ba750fc1bb7fcec7aacbb886a249e81825a8cebd63eb9fd4"
    sha256                               arm64_sonoma:  "5ffa10ad47a0d38bac7b0741dd7c96ea8f8190623377867e9e9d945d77e08996"
    sha256                               sonoma:        "49c7f3ef0284ff05f115b22d230fe39cf8c2fecd50893989428a35a84d8dab42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4fba5354d912753f754ae445128010c02b393e8c5235d3514799f2a4af9e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd588b120b9232524831c71026bc4d38cff8eb01d456b92cf39e56c84bd5b78d"
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