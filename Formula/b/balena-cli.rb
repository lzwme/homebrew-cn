class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-22.1.0.tgz"
  sha256 "a178636550326bbe9b5e9d1c5c111d9199a2467ca9e4b12d137113a2b9981f7b"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "e2c86b019bdbf5ec7bf05ec1704dbb995ccc5e2fa892a8a52e6e83de5006d4e4"
    sha256                               arm64_sonoma:  "dcf0aba7b1e8411febd1fbdd4c01348aedef9b5ce9bbc7bcbdfc11ee5aaf48f5"
    sha256                               arm64_ventura: "ac4dadc33ebb86db7d96f195624aa474864f1b79be03c8066d665d0d4e3832ec"
    sha256                               sonoma:        "fdc455e65eae29b9f30b22f1532ddde39a80046c3f7b03353e0aaadd24bbbcb4"
    sha256                               ventura:       "8a3763bdb9f82d0b1e4c54563860e48ca55875c186bc929b9e9e394bf6936f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e822306a0ee5fd02f1a9de8dbdf0c233cf4d1c84e17571b499c9c9962b35f982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe65ccff3c33075733c2ae07826ff2aea8e00b84d0325466506adb4bf73fc44"
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