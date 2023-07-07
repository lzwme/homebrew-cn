require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.4.tgz"
  sha256 "0629a0afee0717b49f4595dd51d0c3f80774c9a147c01fc6e9c3a2eab73614d5"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "65855168f7cb2d80d05024e8dcdec962696e88bb896239bfe0ee57f737710c36"
    sha256                               arm64_monterey: "b5e1067ffca6e45744918e38bdb2721ffa4bcdb1024d165021b0d4e8ef68481f"
    sha256                               arm64_big_sur:  "731e84dc7ffd58b57cbdadbffe250264edebb596ce1a7654ff3251f4d6c5bb89"
    sha256                               ventura:        "a3311a4ce96615d71545349ea20f11b870800790687e9b021c5e84205cc9a5a9"
    sha256                               monterey:       "da6408e82045d9cb1931f0bc81f2ae491014d29360ababc106316dd5a7c47afe"
    sha256                               big_sur:        "1b8366a5f4d388501b0ae3c924d3dd001bfae05e90f5732f39e0b70210d2d45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70cec069160ca0ec2bd0ed36178932c7e028c6373dec8c6422a85bc906a1243b"
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
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end