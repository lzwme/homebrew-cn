require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-17.4.12.tgz"
  sha256 "c0c4daee7e3f76ebb5588df3c3a0e2d46945a91339ca78ec758da9e6fca17e8a"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "d567ce1b9aee2311ce31fc9457371eb80073820244ad9b165bf3cc8a0e2c9f5f"
    sha256                               arm64_ventura:  "652e1e7d1e7dd918efb0fc8a9b1b9e2a5130b44795254d558c96392e88f05a12"
    sha256                               arm64_monterey: "244c0eac2bec2e01031fd56101ffbb8394cfda6df09a92b95ecc29c46185a463"
    sha256                               sonoma:         "291b671f97506dc652a22f627d798188c9d250c2266a14bfbbcd8c0ed354cf3f"
    sha256                               ventura:        "0dfa441bcdcdad52f31f4dc3ac367eb19062fda7060fbb10ea6a9db7d22beb8f"
    sha256                               monterey:       "d80977c4077034ca253d5b2edc2dd9eacd6026646ab851f5bce270e8c9ceed41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f75a316446648ce3f617c0351048c08ff7ca6145ae8a8054db1a2ef724afc6d"
  end

  # need node@18, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@18"

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

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    ENV.prepend_path "PATH", Formula["node@18"].bin

    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end