require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.25.tgz"
  sha256 "c5aa11a902a73744ad1acd07004c46244fc709b5ac44239a56b1b94a9d66b1d0"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "87a5847634aab70838b8dc954bad74a54b8308aacb2555396219cee62c7c16fa"
    sha256                               arm64_ventura:  "d84d814eee72c6849a16b1cb1a5b435c7c8fd31b65a8cac29656f7657d0e17dd"
    sha256                               arm64_monterey: "20760b7d4cca342491d62fe1a1d9933ce82d03e1d829c8bf0d2785e44e864e6d"
    sha256                               sonoma:         "2a169077a6e0cbe4e5cf7e4644c6fd264aa1c1d3f6c8765f15d9a4f69437e82f"
    sha256                               ventura:        "2c834b182d7c352f7d2d1fb9b7c439d5be612e5c9c0621e9703176240383c7ab"
    sha256                               monterey:       "cd5978cffe445e1a254a1510a3525ac8485317911c973cdadb2ed221eda28300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28b9709c6f518f12d3b4bcc8b3ebd1c652b7316dfebf311de2cca313ffdd6a9"
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