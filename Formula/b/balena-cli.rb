class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-22.0.6.tgz"
  sha256 "375f0478d22d235b7b15190dd4b3c60b459b9c118ee709bcd9493d55eefa570d"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "5f75d9a7b14a71b0dfa9cb11f44df0c3a73a26595cef6c43f3dafa948c3181a6"
    sha256                               arm64_sonoma:  "0c1bc01717afda6dce62921c2e6da0de400a49761728bce335ec20aa28bbce6d"
    sha256                               arm64_ventura: "990fa57c89c5ae07b9b1926c2a0dd831e66e54aeba49b96c0f5cbd4d100b9e29"
    sha256                               sonoma:        "1e1eac5aae5ded0a8b2c00c937d5061f02f764a4326b4babd9cc1501a821079f"
    sha256                               ventura:       "eb2540054a3dd056c8659f0f9c93cb1479e5c7212ed7586a3412066f8bb0b9d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025e698103b5890f605a3667b76ac8739c36869af1a5f876c09ad63455bf5fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0ade570eb626c1887faab952a24839e70f95f114b71feea4b6a834e7f074e0"
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