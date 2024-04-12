require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.1.9.tgz"
  sha256 "c0d4a5253212e9f39cf30133e0329294f2cc719a3d7cb65cf5d77e00196d4f43"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "02ce0f074c4948f78da6e3269daa259868e140269bf44ded1dd9e4ded91c4e8b"
    sha256                               arm64_ventura:  "0b6eb8929425b2a743ba596ec6a3d1b49b2f6e6ef0f6b98186d0955ae4bbe0c9"
    sha256                               arm64_monterey: "d2a3bcfdbd98ecbf252578d4bffb34c258fee5664f5ecb855dad5d95bbd41a94"
    sha256                               sonoma:         "a7eaf736cbacb4582c15e604b94bb16b2634969534520e06f63fde44bedc7ff1"
    sha256                               ventura:        "3304ad3d49f045863d41c0a155eee1e524091ce7ad89f89c523b777d13fb26ac"
    sha256                               monterey:       "fff86b3f4a2e4a90fa78c61dd23532a35f59b1e40578d5d9a12f58f1e173dd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20216b59f46587e98f49a55ad86d9ea9eabb82b27daf4c5efea842e140f1045d"
  end

  # need node@20, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@20"

  on_macos do
    depends_on "macos-term-size"
  end

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
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules"lzma-nativebuild").rmtree
    (node_modules"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules"term-sizevendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modulesmod"bin"mod).unlink
          system "make", "-C", node_modulesmod
        end
      end
    end

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end