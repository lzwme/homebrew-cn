class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.5.tgz"
  sha256 "ea934f24bb2954afe18ae89a5d13c5438828b0c8addfd0a2a81310392772fc64"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "9890dc63c38193eee1664483751f3d84306c136284c4488072fe247f8be90518"
    sha256                               arm64_sonoma:  "1d2ec7928412d1c8d47abd9c6d6015baac76d527fe15851cff33adf09426e942"
    sha256                               arm64_ventura: "4bbab398d443a90a22695c5c0a02d8b91bf0c801a1617da05f898e3015ecab0e"
    sha256                               sonoma:        "fa2b9f425f5d9f9ffb9a3625741f377d76e29c725a385272b6c4b75009b956d8"
    sha256                               ventura:       "f1be76730d01cd0f9551e7cd070c9d1e4672684598dffcd4637e014e75150b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8eec445a2974cabfe79b1bba40da69d370227eceff18c518036374b5a5fc51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd805947eeb601d0d2ff1de7615f24a4f210a9b961155352e1ecd60c0850ed00"
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