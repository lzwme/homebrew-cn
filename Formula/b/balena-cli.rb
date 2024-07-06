require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.20.tgz"
  sha256 "1130dc754bf07e5df2231b2b9a59b950d045110028bad4f55f03bc7e8d5fb5c5"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "c886272814a5c5d3f835373c9a1b01e8af49d8f5338186238e714074da69ac04"
    sha256                               arm64_ventura:  "f4b500f8494d8c5978c6266da5b7112728772c6a8088940d479d9f64112f8df0"
    sha256                               arm64_monterey: "3aa878c5e5e6c848c9e15ea7e2b966d533d332fb955e86ccb209b2284ebdab41"
    sha256                               sonoma:         "5d0aa8d0120387c924e5a441dc2614cec3d6fb6dfc4ee9c4f97a7b11949179dd"
    sha256                               ventura:        "c5a87cd664891b37dbf93af6b7be2e0d76804dd829b420a4205dacaeb15cf9a7"
    sha256                               monterey:       "98602e7c79d744427676d1b3893ac3bc61756544a4413c5a4eeb5bbc44086789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6334acb7eb387e494148b518ceb90132309327ee3cbeb1f7f36a71f13fdc51a1"
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