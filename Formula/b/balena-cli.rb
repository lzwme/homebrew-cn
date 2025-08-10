class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.2.4.tgz"
  sha256 "fa3e383e7a42bc58d1c1c668f120656ddef4f1928fd015085ebf36780b456567"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "4527946ea9204362d0ab47961469f5ea6dbf8e0eb41028bf3feac9ee9c13a9e2"
    sha256                               arm64_sonoma:  "dbe4fc7bb2a5a95bfb0455f45d38cc7e36c37b50d83916e5171df89ce072c97b"
    sha256                               arm64_ventura: "333bbee121c066f4f1836605a91c652b7d962d752c03e37fbb3a48829a16cdec"
    sha256                               sonoma:        "3a8b8b094f0fafe1fb5836766bb77bc9794c88d107213a8cf022c37b7383abd2"
    sha256                               ventura:       "2aaa6c72d59db70e0645326dbfe7c36207a18e2d7eb3ce1c0b6f646195acd1b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae1054ee2f9e70be257e0674aaeeea439bcb461172fe6f70fac9d2d380ab980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e9bc5e0ca4a4434fd142a6d76a1a52c46b9e392ecf66c398c6d1387cd24f53"
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