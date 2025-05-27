class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-22.0.0.tgz"
  sha256 "1ff727b0fb4723c393784a65be990731bca9f6245c216c97950fe4d38ff567a1"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "af3e87140ceb820050bd13ff7a8d358ff2913051c2379ebdc3333cc0426d1936"
    sha256                               arm64_sonoma:  "1eac6874f1a14b1d8f39226f3c5b1f0e56a1720c01e6f94ef43d144859753209"
    sha256                               arm64_ventura: "82df13f569f4e638bf5cdefc04bcc16613c06a39080aa738d2d8645e4e5c0521"
    sha256                               sonoma:        "0122849f763bbf54ee7f0a45fd2772eaf4ad27157667835af64aff99be22c264"
    sha256                               ventura:       "7708ea00cf4d6e18eb9a4e0e7be70fdb8ea8e0027d78c25cff72a80df2dd25b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d0b673243136169be8701f6b4778ec6bddc509b479e9f93d8a42ab9442bf4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6176cfb0d6678085c619cc454c26e8432e17d83a2bb2d1e240a117a0a1fead"
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