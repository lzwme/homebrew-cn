class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.2.tgz"
  sha256 "b5646aa61d2c656865304cbac3f8ebf080345e99dbe1d9e7ce3549ac713d4224"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "ea869d0662468db15817371174dda2014860ce67fd9e00344500538890f9f3b0"
    sha256                               arm64_sonoma:  "8c058d48028f46da2206e891a1639822ecebe25e35d96d0025d240355592fcb9"
    sha256                               arm64_ventura: "acdc7fe215862b32c56a894313ab1d9971279136f1d54886c31e53cf00ae7f02"
    sha256                               sonoma:        "e40d10c378b479d9c820e11e950de43c97f0e109cd50fb34e7cf5df13784b031"
    sha256                               ventura:       "175d2a3228e6850d7950fb97527ba6b6a7da2741f0b9a05f5569c71c8559b53d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e85105240ac63d3dd446742e297dc590a51dc638c724be5fdb2ed6be6b9f39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4dd3ad7a59437d43ad6ff4adbdc9576cc682108925f2565ff35d50be34ce6eb"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

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