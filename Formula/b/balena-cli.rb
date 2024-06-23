require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.10.tgz"
  sha256 "a2c867b33936019372f99b08db7b14b3c7405bdc95e947d4a4e7cfc7383fdbf4"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "6f6ee9c67989fb569715e55047dde2baa99f68933c8faa315ef105effebdd50b"
    sha256                               arm64_ventura:  "ba0f87e44cb12955720f4c1d156159fb3ede48a3f5c07b836601434c629342f7"
    sha256                               arm64_monterey: "d9c5407735a69b48d3d7b076ba0f336bfdb9ff46693ca020c658596d13d49740"
    sha256                               sonoma:         "77828b4d230ece3d61d731ba43e73c1f66b2ceba7f3d2867235dcc677b500257"
    sha256                               ventura:        "1c07f283cc89e8fa18b70685a6928d670a5872824bc7f9de95ecfa43c001120f"
    sha256                               monterey:       "d111833c5c4e46dc146a3e236bbf0931f8d2ac077ef4fdd1169662d39317b519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8689544df8ae0efd8d4c6b9cb74d8177dbac7bf4f00ed24f78e1b347ad7649ea"
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