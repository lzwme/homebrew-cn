class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.12.tgz"
  sha256 "d8160955173dc5e291c9d853f483dd867d62fcd198153652d10e069642286056"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "b947a7d1b203553a878d845cd30508fb4047b7eb593738bdc7260d6aec0a8748"
    sha256                               arm64_sonoma:  "111da4bfeb426f426f04773209730d61b006630c2173544b8704c3c877022b29"
    sha256                               arm64_ventura: "641a9e632bbc78b17f0226ab1c54b35dcca39b780d07ad2a70fd87610bd41e16"
    sha256                               sonoma:        "30abfe785f1107814504a9efcdc7319a16c8d3064a209e01ea1b64957402232c"
    sha256                               ventura:       "4a9aaf9766bd1138baa5c97e6d9fe7f04457964f97aebfc7b53c97e44ce8e669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0c10a62e7cb25fd2e2f45ec78dcd09ad74198645a29424f358befc5c1e9017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d3dab76e70a384c8c6577c9a4a2ffc42a453500b63a764dc91596056f40f86"
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