class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.1.1.tgz"
  sha256 "7c006ef45ab98e8a675b240bb474427f354dfb9e6e576612e6101630ecd3b7f9"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "c13ee1f0021db152f25f19dc1dc3d0037d8a1fcb2b4bf066e84df0cb6566649a"
    sha256                               arm64_sonoma:  "85ebe50dedbb57e4086c8a6c70a36e103a54c025ffada6eb5ad531ef8c277ce0"
    sha256                               arm64_ventura: "1af6cf59dbe415f5dc6c387c687eaa58cf3283b427304549b8d023ca90c05a61"
    sha256                               sonoma:        "db6358bc75a51a4eb6a56a1391ae76ae279b1d85569d0586c2df3082c1b79e1d"
    sha256                               ventura:       "15d755ac3901f6c26c58aab2253b4b34c8412e683b9e4ae9040dda1618cf3cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc42e003bbfc6cd182901a356a5dd52c6286d587cabca83d79301ad12c39955"
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