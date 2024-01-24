require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-17.5.0.tgz"
  sha256 "338e47ba52ffbc556bc6f8b34accd4e0de5f31046f2ee971ab86510fca23c652"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "abafc4b5e4a623580f1d10fe661a966a34d603433b2ba58d530b9b532221e64d"
    sha256                               arm64_ventura:  "813c1c8fa64d158fcd2ba293f26983814f68006b6f8adde9e11f1a05b7356d26"
    sha256                               arm64_monterey: "088a9c207d47317bf6cfa7a369867d6d27a1cd29f3cefeba5c49a14e8a265e44"
    sha256                               sonoma:         "648cb42ae89215cf754e6f591fe3d9166fa7ba3bfb4a6964dc06f0c40cd6bb02"
    sha256                               ventura:        "ffcbd70cd9af00f04138514c3b42f700b9b8e73c72050c8615c55edb7da03416"
    sha256                               monterey:       "2720c90596983bc527c4265c891d81ddd03f7670efe0db1c2259532526fbd4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c863f7165a95161a7871239716651a461604a060a4f2dd5df7361d8b1a3326"
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