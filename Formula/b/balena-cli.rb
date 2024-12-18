class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.1.2.tgz"
  sha256 "8598752434e31062c41ab647903dceebb167f8f6d3946179fb6915ca3c69404d"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "249b18d3e3d6dda1b7ae7b37c4f0e71a8d1243fb392bddcd9f9b2591f8b836d7"
    sha256                               arm64_sonoma:  "2c649aa8aaf3d7198c476bd85c889bb7796e00b3348e9518a456b449fae105b5"
    sha256                               arm64_ventura: "1c6d6cee60d5974362913c01101727ef7f2b38ea7142680785f67e26ae64fbe2"
    sha256                               sonoma:        "65b67442b7fc4799fb21167c27d64f6288d465c07f103db54840753409f198ea"
    sha256                               ventura:       "2190094e0f272730f0d7157a923a549056aa185ae31ebe1610915a360e255880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0649140e2e6e179894458b6d4815f6a25c565b9154462300d4cec0a520919b54"
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