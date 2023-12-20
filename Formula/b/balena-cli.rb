require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-17.4.7.tgz"
  sha256 "cd9a2dfb0a2298d48650b6a53c76528ac51b5078e80fd30e7ed95aa63e11c55b"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0a1a040ecdd33d307c30a4ad20707ebdeae1fc87d15852c60d7e0449f703f1cb"
    sha256                               arm64_ventura:  "4f2400b6e44b8e11089b754743e5418acf2612cdc53747f343044a6f67654724"
    sha256                               arm64_monterey: "d488cb20572bb621ef4f2a291873218269146700aa98ab553e165ddf4aad586a"
    sha256                               sonoma:         "7b0dd8231010344c1a6ebe6985703561cd6a8f568b3dd029c712bf30f7802351"
    sha256                               ventura:        "a3d2f6a60259e7667f7d1e06731dfd939acf1f9c33f5c1d72f2d47bc4ed5cf6d"
    sha256                               monterey:       "e9bb4398e76bc9f1968ddec0df55f308171a9d8785feff6629e69c839416ddd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b495df4cfb4b8e3f290ce826d7461072921fb9551f1643a3aeb8ea606029af"
  end

  depends_on "node"

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

    # Remove `oclif` patch, it is a devDependency, see discussions in https:github.combalena-iobalena-cliissues2675
    rm "patchesalloclif+3.17.2.patch"

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
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end