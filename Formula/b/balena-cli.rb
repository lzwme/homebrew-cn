class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.2.2.tgz"
  sha256 "696f19c0b54b0224f131b9c5251441c37ea7ab889e7058acb7f57ae01513fdca"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "946a0b17bed973010c1d85f237056623cf10c02980d00a25a4092c42e46ff2a6"
    sha256                               arm64_sonoma:  "688231262f911d6aa252d48af1064aeb8948c5c5e85d60e52438f3436297657c"
    sha256                               arm64_ventura: "ff9e84dda19c669aa62e84127d5c9f74c5bbadee90e06361e602a8072604a111"
    sha256                               sonoma:        "da70c9550c4c8c976ee953698d1719808ac7a7629ee93d2430c30e270c808eb4"
    sha256                               ventura:       "28d33cd9ba79519cbb1680cc1280be000a0aeea2a84c0ff7504fb3e82eac96ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beb381395d67b7664c36811fbc3eb8164a5d87d5436411e23ac34f2ada991e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c2ae4bcc6d5b786dd9d1bf85220235f175591bf6b3653199a3d7e9f389be93"
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