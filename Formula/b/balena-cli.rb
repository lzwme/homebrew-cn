class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.10.tgz"
  sha256 "5ca1f8a310c37f26608232d588dfb5d7bd34d481f87358ccbac89319a3741a1e"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia:  "e398750a73d8510323dec93baf9acc9c2700aafc68931897646c5e7a539a59fc"
    sha256                               arm64_sonoma:   "c13f617980488a6b3bb98e1d9b3bcd6be5fc3518317c08590e8f16f38afc6e7f"
    sha256                               arm64_ventura:  "a97316dbe251a01169ae31b7415313eb95a0765eba4313a7d354c9f7ec346169"
    sha256                               arm64_monterey: "fc230761600b62d34d92122aa41998266b8d6092ccf9759ac34ed7393ae41beb"
    sha256                               sonoma:         "656a9613f1c72a1418b8bf68ffe417ec3fde7b88f4cb56613b0527fb6386dc09"
    sha256                               ventura:        "0577a75c62f12728ff3d4c2a4d6429a699daa21cb49aad86bd9c94cc8af34892"
    sha256                               monterey:       "ca38fad3b883a40357bfac53f6e4603fed665869e5da5b3ee51811f74acb6b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4cea8161eb2392232fd42c523d4092c20f791101fe58af79f7b2ea3f109922"
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