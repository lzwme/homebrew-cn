require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.1.8.tgz"
  sha256 "a5729268e831fa36f75ff6f048dad920eb923fd7294fd1591dbde59465478e39"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "5902a56760623d3a1646b304b8cab40b0b4c689cb3fd8c7a5589abbe2a3e27c1"
    sha256                               arm64_ventura:  "2dd380689b43ed15206388afd48df1a8ebc1baea528b14bdf8eeebbf3587c6d6"
    sha256                               arm64_monterey: "fa04c28ffd7bf54cc683fd2366dd61639754e7c7c040fe42c3b6bd1062202a4c"
    sha256                               sonoma:         "fed78907665b51c258dc0e6649ffad6c6f391e1ea742da1ef141b332512dcbe0"
    sha256                               ventura:        "5b2bd59ba458bbb0309e04e2049794d129cec4fdd567660e367ad5c66001d27e"
    sha256                               monterey:       "56832af3d9b153b63bc7106ccb319354b040a6fd9206920703c776047dfcd749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdfd7e9e32b9f1b4b8d8f5bf84a62c029f0c705b7d4f5cdf37d9ddde259306b7"
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