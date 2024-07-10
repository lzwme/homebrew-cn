require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.21.tgz"
  sha256 "ae7ae249104a32c028826f44ba975bb6cfa016588da5f7388aa6e406b87e462f"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "c3a37846c39cc02c1d3112098a9f58a2d7d49d4d62bfee01711967fb5342512b"
    sha256                               arm64_ventura:  "098cb3c62d5bda4e70b88f7507996f39f928d5ad19415d09cd7224e1198f605d"
    sha256                               arm64_monterey: "53564d61431872462c039bee7783f940dea19f35acb8f06f834ca87be5bb0331"
    sha256                               sonoma:         "f062ae3a4a69a056636afc075963e65d8e5e8723bf9973535492075688d8f4df"
    sha256                               ventura:        "c5fe487723408e65906b9e3ed0e0b36348916bb3f1ef6cff56b5f7c6bd2ee144"
    sha256                               monterey:       "a6f6c6555f87779bd0528bd9abcbe78dd2932ff6ee201e85bec431909a4edfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b9f7c3af9d114dee11c06d459d78715cd25495afbf3fe5a4617a94864d0bc8"
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