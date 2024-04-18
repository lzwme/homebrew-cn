require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.0.tgz"
  sha256 "73cbbbcf531bab4712382acc2e0df17adc393c34aca2fd3d587d1e2b7e4d742e"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fda0482b865a5c6278a4f74324b4c0f6c38776bf91d1e9f52d65326265240665"
    sha256                               arm64_ventura:  "991979fbd20859f0c85587e2ef2f185b746d3fd67cec32d1312011aaa02cef40"
    sha256                               arm64_monterey: "3dc6062a9b8ada8ec6d333852e8d3623087a44637e94605c73c61af40c67d10d"
    sha256                               sonoma:         "7f12a36dacd2b6d5fe5919e59058ceb2b77e6f422c952aa3c85f46dc758f9770"
    sha256                               ventura:        "aab19284073624a3e8efe3b53e83dc0ff08412cd9cd2fd9ca5cff9ecf9b0a5b4"
    sha256                               monterey:       "78cca5f858f97d24d2da201541591e75e6c168cd4b2ce2f411e0c208326ec37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902a1762afb5e6801f82a26d63b66bb5be71f97e9f09c1667cf3aa8a2c80b491"
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