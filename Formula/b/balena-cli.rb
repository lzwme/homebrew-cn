class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.15.tgz"
  sha256 "717af7c163d78816f8efbac3d352d0e9e33898fc049d445d592bf0a911422068"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "f035dce171e85d1af1e55322c1bce957767b6702864e4fe94b0cfcfbc517896e"
    sha256                               arm64_sequoia: "761b9a02e62623bb519ee293bf97719a9c848d82e8db6851aff1b6a82bfdc8de"
    sha256                               arm64_sonoma:  "da20894e606e0af24003c4294dea537dfc2d322b1d33909d09612116b1431ad4"
    sha256                               sonoma:        "521333e678cf1ab391e1d8dac80a9b2c9b12bd8abaf34afd2b8fa9dd86c114e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21bda0219a7379ea22d344a6536d1258a593e92498a02737308b667d2f87497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c380a3d028325981690a4fcbc8bcef798136d2bfb6567641627822269311185"
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