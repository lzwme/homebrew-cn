require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.33.tgz"
  sha256 "9bbec6f27fe46c9028a929e3a9cba679ada54fa527288d3e36f1f1e1c5bf6740"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "62642d0f10e8e647e12d2ca1fc7ad0d5bb054b649f0912876547ee6d744c75c5"
    sha256                               arm64_ventura:  "c3b1b527bb1d488c2a12c47cc415240259a248b0e9f58803b36df474cd395adf"
    sha256                               arm64_monterey: "c513534b5c7d60531df702301a387ff66bd9316ff98ce553c1bad7236522e6ed"
    sha256                               sonoma:         "2d97e783bca2967d3abbffcd592ded35fe58e4a9d76ed12695c0ca09489cd2a4"
    sha256                               ventura:        "3eb5bf6e93cd5620feaafc627a5dbe2a137cbdbadd65a6cef5b962cffd32a285"
    sha256                               monterey:       "a14de5c0e6be6f0f0ff81d1b62d63f69d73e01cd88b14af65f4a5bcfccc0245e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085c71bc99ec320fa3fe37b72d262689b8079316a1e89a2bb7cd05ca51063ef7"
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

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

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
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end