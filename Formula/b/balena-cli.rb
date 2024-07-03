require "languagenode"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-18.2.17.tgz"
  sha256 "9327b415dbb3cbc0105b7ab81a5712768020a8116ca7c78c1503a5280d114d05"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sonoma:   "44eafb564e0c74f08a5239a9e120372eb914f1141fcd8da3674b7599fcca04aa"
    sha256                               arm64_ventura:  "e367fbff8c6d9e689cf91a08c7edd010ffd12912d6718e9c9511477634720b74"
    sha256                               arm64_monterey: "147c4f5e9c7ca945507823e7957261b0fecc2cd2ac8cce8172abc9276eb2ecbc"
    sha256                               sonoma:         "9e1ec197204e2c2534e7627d82e6c10091c193378cf835e062786b8fa8005f4f"
    sha256                               ventura:        "2f012c220030c090754980e220ed8ab09542e206f401463e5e40f5be65492bb4"
    sha256                               monterey:       "e8c314b833f592feb0506cbd6b22250771f6fbd0128ae50b4fd4f018794df6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec257d6f5f76604e68bb393d863b9bf7bf7d8fd43d76ce4502801e146bae5efb"
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