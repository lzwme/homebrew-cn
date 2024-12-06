class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.9.tgz"
  sha256 "1bdda3fa01ebc79b0cfb78f24257ee2c0a0e793053625b96d58391fe4e6635ee"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "512e814ffbdec3e23ed796d7778558502a930f4dd97780635d6061dbb4d061ed"
    sha256                               arm64_sonoma:  "d8726c6f3750fe682498faddb8bb8bb7124ae07fa0ae939e4bf003b53373e6bd"
    sha256                               arm64_ventura: "41a688a6eecaca1c85c44fec467b37b1ca1932cf02d9eead1678d4441b3238a5"
    sha256                               sonoma:        "0c9e19483aa8842f39ec9f8440fd6b8d5bd2b2fd57c4304e329c21d4c8809046"
    sha256                               ventura:       "b4c0308634a62c5ff9534c48d04b9c37c686812e7175a5ee7240b223c581997b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53cc26e7eca050532f3d067218672deece6228200ef22bd364bea9470b071b64"
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