class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.2.0.tgz"
  sha256 "d93bdc5381c1c4dde8a416890934e5882c9a3a9b8091845723341b0489bfa295"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "472ddb491aa64ee63eb4769143ff08ec002b454ce2e5e1c20a9025c272782e88"
    sha256                               arm64_sonoma:  "4384e4176c1ee155a4ce55548a3fafabc9119dfce2eb9f167a3b6b2a708feb4b"
    sha256                               arm64_ventura: "b09b54689b1ed521c2fd0dbbb228ad7ab614245d04e5fef3b185246e6e78f297"
    sha256                               sonoma:        "87768bd10de4e939184fe65b11aa4431b35b8b149903f9269839c795e0695040"
    sha256                               ventura:       "e0a6e70eda02c7534b2f86775d55ac715f22b5e8c85b807e1ee17ae4f5c742c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b8ba7e5400479aed18f3dccae9df2fd32e6dda26925ec33afa656cb60b883ae"
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