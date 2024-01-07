require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.11.tgz"
  sha256 "65ffe83d58abd76aba20332b730e983559698de77b147d37acd1628984965b79"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "d4d76b6e63caeff93d6360c33bf69ccfa033db0e00d1158c7acf569a9f70335c"
    sha256                               arm64_ventura:  "42074d3caa7666b256a6fac491f851f9e9293ca33a1394e3a2200f7435903919"
    sha256                               arm64_monterey: "0669f3610499b2c91d79695803f3e60880577a6df02c776fe2ffd88d1332ce7e"
    sha256                               sonoma:         "d5fb61f82461eb2bc3207ccabd92c2c0cf7d268f6ff7bd5c5ef2b393327efdb4"
    sha256                               ventura:        "e7b81e3a952d87ef251293dfa5d7ea3dca719eb42df92de0c3365803725166a9"
    sha256                               monterey:       "90fdab4ac8232fd4a521ed9e4f5b825ed9f4081aac9a83cbd095bf684ad6ccc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25bf62903ddd57f519b21aa586a57fa6948af277995a7f315046038c707ca3d2"
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