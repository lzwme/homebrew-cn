class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.0.tgz"
  sha256 "ae20e266275fd8cf27a46b376f6207990778b0096bc46e3fd198b0c5a1c0e1eb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "e7547f99aa2b5539004ed93df5ab30defa77ea3eebaa3d6f8100c71fb1c0616d"
    sha256                               arm64_sonoma:  "32c422919b29f04434c5b187070eeba89957876dbcee6a506653ea0d9f50514a"
    sha256                               arm64_ventura: "8b150dc6b9c113b9c5815f598aaaa8543f9e6b104b2727d86206ed922b47c00a"
    sha256                               sonoma:        "151bf6ce19a8713311082b4d5009b460fd57b296cb274436406e4e20a463d4b8"
    sha256                               ventura:       "c307dd8e34d772c90da0ad9da961176da482e7ac50f00dae27a1cc463bbc013f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c9c086c796ca8022ffe788a7be1ff59d4696ccb93b89d290bc900c43f8d7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3843ca5386d8cb71d3f083cc4b2b663e503377cd2c0cc6a8e75b93de9d8a5a41"
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