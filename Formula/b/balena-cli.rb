require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.3.1.tgz"
  sha256 "68f34ae29456647a4ea8d38ae0d58620cde1aa236bfb63eddd58c20c2fc1f95a"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "f23defeaf7eb65a6048b8b9b9e41be91600157e3f7a91f543d391ce5c10eaff1"
    sha256                               arm64_ventura:  "e5557921c4076e290efcffe389f3b82ce0972f04421d8b9da86eb0994936a21a"
    sha256                               arm64_monterey: "bcfebc75cb7d979a99fb0f77452a5a596977a37e1e74a45227e3873c27246aff"
    sha256                               sonoma:         "951f306bf39c800b2d1857d2db99485641f33e7745e765f5d76cdc4a184a5256"
    sha256                               ventura:        "5ce0d7919b94711fe401a7c6950ad303520d9b1fa87041870c3c1c9f9b6b815d"
    sha256                               monterey:       "9f6a567e93fa56d7e3b27f451724c57a6fbbca6f15c318f9ed392aaefad3f00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37f5feccca8c7d4fb4f9f1774ce71e9f6dcc27050e9f12cff87b50e071446a6"
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