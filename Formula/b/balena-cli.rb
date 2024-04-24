require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.1.tgz"
  sha256 "71658dd1bc0b4e27efe71b07d6befb0696f792c7baed124d94283af1dd47c2b1"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "d6e7ca97ace710c6949b8bd850b296f69dfe20bcb1801d883dbaa813c778b8ac"
    sha256                               arm64_ventura:  "ea261510e4a587da7f6911184c5559af2d46aaef597273412f2b9beaa899914c"
    sha256                               arm64_monterey: "4e0deac30b61f03ec9b1dd629b3d1d0e65abda49b250857660a2aa03dac7beb7"
    sha256                               sonoma:         "64dc92ea868ca6a0d80dcf2556605362b768510467f98d531e3dddbc69ce2184"
    sha256                               ventura:        "992a45d23e1fd43fc23161d819d3a91af97da974dd7281f24acbb81692e4f0af"
    sha256                               monterey:       "6d71a4d5ff718a7991d3f957088f8c8e9b98b3317c82c1d15d3cdb9a53903d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d85e42b3be87517b3c6e574ab04e3d7468de8710bc1da5da11d8cf6d2c69d3"
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