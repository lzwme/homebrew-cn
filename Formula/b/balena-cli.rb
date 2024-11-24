class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.7.tgz"
  sha256 "89eada44c61e31c95ecec25e090f9561106d64bf371c15e6deb30d0124f7a061"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "a70db21f0149e2f3473568a7d6de7da048a680faacde757a7320d50dd572b478"
    sha256                               arm64_sonoma:  "224c49ab15dde273c9d7089110522d3ed4e51cfdf86c944f1f15cf3e93b4b5eb"
    sha256                               arm64_ventura: "bbd385d324841fd83c94e4dcb9ff2fa10d96e869cb159b01f3afcccb03bec462"
    sha256                               sonoma:        "c715ebeebdc0de7e1133c608b08f823623c0537a256cd489d5a9bcdc17738b6e"
    sha256                               ventura:       "3542d2842c5b6c9aab40d5460b46faa353c85d7700a9e2c3997f0d27971cc255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac48ed797b34954f6fb51aa892e63748df9b35712f654ac7cbae1d6fd8330ac"
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