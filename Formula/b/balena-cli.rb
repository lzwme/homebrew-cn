require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-17.5.1.tgz"
  sha256 "dbe427dacc9eeb1ba34b10ee9d703ad30a5cfff28eef9b7abbd19c8867d672e7"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "21d2cb0c08422a91bcd7a0e7dfdc8c83a559359e646f74b6ecda4802aa4d833a"
    sha256                               arm64_ventura:  "b40ebb37506d7016e15c2e2ce8442c8319c4599dc0a6700f32656ef49ee83ac5"
    sha256                               arm64_monterey: "04a64fe71f80b78b17f2a6e1b9fe0573c411b5abd54c74355bf3e0b982e95084"
    sha256                               sonoma:         "495f6c20f3ede76b1200612a4f0bf2cb41d035c39eef389311d45670dba14bcf"
    sha256                               ventura:        "f708c0a5ddfc9ef900914a40172bd3952c5abe529737dac96c75f151a4ac8c6c"
    sha256                               monterey:       "bb1ad9fc6ee1b375c8ae7017576ef4b96b9c0480beb9df0919b5cf545d06f6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ba4bba1a9dd1c78249bb89f38f000529db96d3ba381940d8aad4b261aa26ad"
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