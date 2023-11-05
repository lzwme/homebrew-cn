require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.2.3.tgz"
  sha256 "ef96767fe90f132fa899243f324a6850eb21ccd05262da3c888b3ba4cbbeb874"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "0402fd4a59ea99c41a72ff687d2ed245fe39b3e40f008f148eb531b73fe9666e"
    sha256                               arm64_ventura:  "e72f550706e0185fe52d5f6315652f2f3f9b3183a7d543198e8cf2214c8ca2ad"
    sha256                               arm64_monterey: "5bfa54f6390508d4817f325f66a54cf1a6edea634420147a125ac7b23cfd529e"
    sha256                               sonoma:         "2ba88cc7e9d843dde9c0c29156b82b2246069db1730d931e614dc3ad478cc7cd"
    sha256                               ventura:        "5ad9621be870681547b9fec6f28bce95a391515da7eb34f10b510dda1b596259"
    sha256                               monterey:       "63f7b6e9417b95578835f194806d3e0ff8b7e27ccb8f4390143cdd637e7614b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aef795ac2f3e5057cd8b3d59fae748cc4f6e39f064c15c63753c649ed61d77b"
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

    # Remove `oclif` patch, it is a devDependency, see discussions in https://github.com/balena-io/balena-cli/issues/2675
    rm "patches/all/oclif+3.17.2.patch"

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