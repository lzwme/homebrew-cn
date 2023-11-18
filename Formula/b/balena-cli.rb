require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.4.3.tgz"
  sha256 "0be2c0e133c78f0ba46c1b75a51b52a4aa365405a4ced7f8f457b6d5ac4c2c39"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "230a2a46cebc192933c545905e26a6af9fc0bc8f02468a81014d897aa33d45df"
    sha256                               arm64_ventura:  "f6df886b0f68acf335f4226efae430e659cf56fbb1ff160c097006201cecbc74"
    sha256                               arm64_monterey: "b1f97b655e4179811d297f865c718eba4ba060f9092ccf5ad36044491077ceb3"
    sha256                               sonoma:         "370de5e8f1b80824851306579e29a073f26769c3b3a2f1837f6b8a6ed60fdde8"
    sha256                               ventura:        "f0a04c4ee358bc1612e4d388c89a9e896ecbc4fca3a95e395ea0126e1bdd13e1"
    sha256                               monterey:       "fb684e8ec3aed0fc0f33057bd28cde926592867cb810f6010ad2798627c18052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dab4832ee7be763953e118e7ffd9613a3b807ba324bf32bbc8a42199d022f01"
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