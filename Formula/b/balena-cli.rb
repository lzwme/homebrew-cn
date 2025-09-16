class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.4.tgz"
  sha256 "ec93ad9f0712868addedff8f2f1b92dcdf21b94261585539d3b10c92ba75232e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "72ac215ede7af252d5c8c8b0cd3b2fe096381b107e672aa89a21c6316d8bef48"
    sha256                               arm64_sequoia: "1c4e8216314ab50d83f2776ef73ecb5bdfb41512c51d238dd923bd145fe896fc"
    sha256                               arm64_sonoma:  "a373abcb4405947b7b6d1ea7805dde225c2a90c4816868a59ebb8a25326d9873"
    sha256                               sonoma:        "865ba1d5fb26f62cc5dddc82114568431f75de77e37d6b5761cf73c87dad6b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2002a6cdbe096f84f409ef765fb4bac3252bb9adb59d888d2c1a2fe3344b6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbc4506bb267f260a1fd3a20eddd97a9f46469ddfc27febbf3336df7b0890d8"
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