class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.0.tgz"
  sha256 "d13699b0a54d46d6f0acecfa6f0e641cebe4d55d5961f08cc6421c1a8b958d19"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "5d0c741f24eee7f35e29cd26b48fe4d28004a1477cf00197305ef5e2fef2a468"
    sha256                               arm64_ventura:  "8e2b6b1332c9a00a893d5aec2b9f373ceab7ced11ddececfba51ce6765f21922"
    sha256                               arm64_monterey: "22faf552da0fb9cc812a7d156214832265dea30c4ff01a075fbd92c87df771fd"
    sha256                               sonoma:         "2a11079f39cd16f46ad59bbbd37c136b6d067954e777fc163ffe7932bf027f2d"
    sha256                               ventura:        "6682eff6ae607af27955e2536d1104cc21c45a25725d29c537caa30a5bd4a6a4"
    sha256                               monterey:       "e462fd7022aeabe83b5d5f6a920dfaf5c19e7b8f064281143b8cb770dfbea843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7f4b69a014cd31c240b2284734f5f2e323dda7131c3a8c5005b03dcf0a3884"
  end

  # need node@20, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulesbalena-clinode_modules"
    node_modules.glob("{ffi-napi,ref-napi}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules"lzma-nativebuild")
    rm_r(node_modules"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end