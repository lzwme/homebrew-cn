class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.26.tgz"
  sha256 "467ddd9798e8d22df1cb2140fc567c60f8e837c6961086f064d2bbcf0fb10a6a"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3255dbc20b231809332f77b2bf1e08985f98661f9b3fd889c04e7303dcfbc9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "797e019bfabc883904dfc210b15edc0ad6e6a3e565d724ba30b44f4313fcea56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797e019bfabc883904dfc210b15edc0ad6e6a3e565d724ba30b44f4313fcea56"
    sha256 cellar: :any_skip_relocation, sonoma:        "4925b7c1817befe20d92e4dab6fa601bb749428c5eaf126a31196e23b1edc8c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62664852f0c022c86e7ab61ec0bd41b7eaa3a81374b9735b797f4ee659b075e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807fb60a36fe77ffc47dd8483ca3ac2440d74eb21ce95e7ece4ea41db1397f43"
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