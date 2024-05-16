require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.3.tgz"
  sha256 "fe4f9d5eb57a4b4045b8e2421e4a4027edfc48b239b5c45a440c8c8d0081d275"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "3146be300835c4b6f67e8c6338a0e727545c75bd77eac80e5db1862326ddb84d"
    sha256                               arm64_ventura:  "0fbb5b9acc0dacb4fd2be37c67e161a5762a3579b7208dcd7ed04dd522ee9b1f"
    sha256                               arm64_monterey: "b8bc4fa94f675abe5229710fde33be1a45ac16dafd067e0d42553b81fae20b21"
    sha256                               sonoma:         "24e85ac4cd1f8ef4356a62e37550315884dece33b5e7b48cbd2a595af7684e2a"
    sha256                               ventura:        "740caa107bd6890999832b04c1be26ce974d0443bf3c729109fd6e1128f1b044"
    sha256                               monterey:       "dd6822e8e86838ba7b6a521bdbeee9dfff7ffe042b8ed13bbe3dce6079bc8497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "663f6daff6220def1c044f64291ec97925a32effee54cd1ebe4c9df14692e6eb"
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