class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.1.tgz"
  sha256 "0171c31a5e7f7704bb7ea71aba1863258b1911b98d6072d1eb79cd65451e7e39"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "ae324463f2f30c0e0f132f89604aee5bb1b96ca01c44a5ef0665b2561250bb5e"
    sha256                               arm64_ventura:  "ef020875cfe2c493baf24ead26a9fd1564c490d8f34c8120bcc7ca6437607ab0"
    sha256                               arm64_monterey: "476b99f582a3db6ad8614bcb713053ba0efaf997f3c1b5804baccc1307a65d08"
    sha256                               sonoma:         "44ec5a09a97201755fc111e284cc9695ec9cd88bb18bac340ecc29f2f9706891"
    sha256                               ventura:        "2bbf4b1eeac868cfe7d96117561576bf7f6fd79d04a3b5b33ad40a8ac5b69106"
    sha256                               monterey:       "67673045bcb52434b94676b07bab782375c2e818531eea6aa3678da3edf31196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa03fd317dc1b423d4fe1ec6676a2be9cbe24c10be1535b6716146baa22b873"
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