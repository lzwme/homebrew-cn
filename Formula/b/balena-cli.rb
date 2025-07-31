class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.4.tgz"
  sha256 "52ef56c1072e3720f9ef18a78f4c0755caf84b8b06a628d096efe2f2645afc30"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "00f6c60d52d4fe8e4a13de5d55d53d838e6027d59fb11558b1b0403ccf412c80"
    sha256                               arm64_sonoma:  "3ef96e3bf6ac225b95adeb6bdb75ecdc8bf80febf0dec75f92368a5cdacff567"
    sha256                               arm64_ventura: "0891d1c8789cd9373dcab9416c4f3a099dca4467facc532f32daac2a17e6623c"
    sha256                               sonoma:        "823879681ca58133d222fbf031e25e6d59d336206ebd19b386871f3e431d8a38"
    sha256                               ventura:       "e7232df20effcdafb84594678ed74db40806b46b4a39feee52c416632d164249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20664c07e710b91c822ef922af699fcf6c6611d4d5c64117e75b9ed9699f3ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d320d127dd89e2fea18a337a4ef075b0cb330f3447655489b97d319fada22c95"
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
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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