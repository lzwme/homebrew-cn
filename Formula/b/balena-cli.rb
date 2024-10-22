class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.13.1.tgz"
  sha256 "0b5f22e8801339855bbd299d2d5588f18bb4736db2224da786359a9a2f7588d8"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "861f53d6941ac9f8564359d0e66e09caf7d1699bac50fa0402a9ec933516b099"
    sha256                               arm64_sonoma:  "395715fe3a0b18663975739ebb874c0f1b4baf1201cd81a1e948e2cb68c1ecfe"
    sha256                               arm64_ventura: "d24a6926a6fa57d1bce6754729ffc7ae28f9d58e5fd776c0fe1114ca15c5f477"
    sha256                               sonoma:        "e3dd5eea92958d1c7812e19e4357f8703e01ef9c8f68044527987308bc345e0c"
    sha256                               ventura:       "e3a2af8f053943f009c94318e947a2d1ace5e9a64114c8c5b2b48a0ce0ab679b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3cda35c26d56d797c227ea0dddb7b3c8d87f6b62ec852a2490f436852a0f26"
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