class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.1.0.tgz"
  sha256 "b0dd4b84445982fa34ed65b887d9005b04f86f2b2a4cc53897eca77239042c38"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "69dc3327ddc97dbe0e830acd07653a7ded967c0504083da77354afcd8d9c3d39"
    sha256                               arm64_sonoma:  "514ede3f542e29f7f69ffe7c78ce8f9ef08ac420f555f09fc1b82ae33390c404"
    sha256                               arm64_ventura: "c61048cc75d184f44ef0ea8817cbbd8e290b8301eb31944a3b0e6d8cf6d90e91"
    sha256                               sonoma:        "54a21cf8a79eafce06830f4ef69f13defe87d69348543bef75443981324b82a6"
    sha256                               ventura:       "592267b5b3d2e09e6d52bb80da46987647299b57cd34ec0789f0a7b1e9346adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a42d67b3bf2f5b8248f5ec4ad5f501bdcdbd79bca15fae693838b0a99bb8f75"
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