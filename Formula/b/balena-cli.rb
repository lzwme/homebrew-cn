class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.14.tgz"
  sha256 "96e25003751cb6c72a44ded3b410303ffcb51d8a6f3b06b55718bc8bf7df07fa"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "2a9a9a119f1d2b7fe95c712cc9a41c4e44353de92c0cceabef2ce3886487deb2"
    sha256                               arm64_sonoma:  "25e80c0ebb3deffb7082d47e20c322dd6d733692ee57218f3dc7afba553bee66"
    sha256                               arm64_ventura: "f229bd533ef4f1d3347c1b19c0e707c1561933ef5656c221e092b417067f5ee4"
    sha256                               sonoma:        "3717b70edd7d28ce3adfb544cd72a8ca5a79e58f518b698c61c483ebe8eab4b3"
    sha256                               ventura:       "8c8f6c84de187d4ef8681ba55f8317ccd050e2827ba85feb2703d7b50e6feda8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a7feef202faceedd3a4eb1b80691047a4869b68e4528ad78f5f77e8011a3ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc5dd954958f48a4a2f7a8ac525b661d8061a6280b7c84e7a25598bc0069845"
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