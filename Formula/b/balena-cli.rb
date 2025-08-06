class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.2.0.tgz"
  sha256 "c40783c8949f977f6a09ee7426f318af26b8cefa8118804ab59da5c73b8a2184"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "8e42f63983653ec74b17dfb13903b96386eb1ca24e5aaa17b59dd8791aedb34a"
    sha256                               arm64_sonoma:  "415cbff423aef01a9e6ca5a930982d4527d1faca94af9b315a628c105baf539d"
    sha256                               arm64_ventura: "ec005749481ae7caa65c19e11e30216a67ea8918e4bbef346b06253675d732ae"
    sha256                               sonoma:        "ce336ab39770d4fea0d6fd31f1ab4aee4bbaf70a7ad30a42a9ccbc102ed2f06c"
    sha256                               ventura:       "832cc6c61cc93fffee910fd4fa1cad8ae2b75600c10f344955ef916bf624e9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae11d40527cd9656056341d08a02ac926a3aed625b5d2387fdb31026acb276fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e84803e79932fd10aa22bc6aef34b39bfe461c69bf9baa248cec301bf2c65b0"
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