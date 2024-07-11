require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.24.tgz"
  sha256 "c7bc13548107d4e2e5458be0307ed42a8957d9fae0e46c07e7eca710ab6b5cfe"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "cf16f741563337ec8b16d212b8b77740029e363f7aad7abb9d353065ea260d46"
    sha256                               arm64_ventura:  "aaad6434d82bf396653a35fe06d67ac49b4b485cd9bb542721e51ed4af2f1135"
    sha256                               arm64_monterey: "60987cf1cf9800986a6f0a2d1b3cf1ee140f03580528c6aa11c3105e5e1e8a31"
    sha256                               sonoma:         "88a99fcafed9288418cb6f772baca37e205ce3028c668a3e87e7e74c68498ca2"
    sha256                               ventura:        "d7d50e785545e2408c9823f7d648c45bb66241c5a20ccea89c25011375e98908"
    sha256                               monterey:       "3538f19b3f36a37e3d0ef0e575cea0a852dec1f351f3932ec0865f5bb03b1ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be23ec5100689655c9d154fa6c9038fac6982444440961c6e75d9351bd70d4e4"
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