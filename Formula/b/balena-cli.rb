require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.4.tgz"
  sha256 "37f52d447955830bca272e939d05af8cbe168a12f5db219448f559ab5831013c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "17044164f433f97740d2aa8b63cf16b309fa956280dd4549d1b8d2cab6784643"
    sha256                               arm64_ventura:  "c604663dbf40521421265ecb9e1447b2594845b4b29c704a4ab3e12f780cb0d2"
    sha256                               arm64_monterey: "b9e29dbef798ea87fb4beab6b20533c359764ccab25337b732980aecded03dc7"
    sha256                               sonoma:         "67c3f4985f2f26f2e643523406dc9b0bcf0d0d9b89c850e5f4bb608ad877a9e1"
    sha256                               ventura:        "56a6a82fe0ebd03b393a9c24292f0c928cbdb542f8f6a6058b95e707caaeb376"
    sha256                               monterey:       "42bef051c1e49b49039aba7f35592f1d1303b21fa0c4ac8096e21b777c30bb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755c02552df84dcb92ce2fb39a1dfbde775ec55f35e3c753bca8816f5c7350d4"
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