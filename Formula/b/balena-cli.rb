require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.8.tgz"
  sha256 "622dcd4711ff599f783c7ef7c3dada1ed23df952eb90a08e8bbe5d5b18a2b1bd"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "362a23ef89c281068fd7e69a9d3012f0b1c84425f2b27850877fd9a1f67a306a"
    sha256                               arm64_ventura:  "b7d585027d302dc62fe946fcbeabf323f86ad17a914c522e94268e20ed01a818"
    sha256                               arm64_monterey: "9eac32b4035045bdf95f2341f92537ae5b3becae736010aa056e95650d267f7c"
    sha256                               sonoma:         "856ecd846d5a2c3c963d63c97b0dc2e1d90abc421376a9c509c4095c17d5fb5b"
    sha256                               ventura:        "defc0fa39f7300c1d6e61ed230c53d4a3a07d5bfe8eea65afb945b271ba03839"
    sha256                               monterey:       "add02c49f47473b199d1a772e2a95e2c85f9742ade0851164f4251e4dc367d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e11d725e6d169836a5bd89a443e9a3d5262184ea6ea523ba35d4f4af63f170"
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