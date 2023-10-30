require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.2.1.tgz"
  sha256 "778c6654959410c52354cd0dd34f969a06cebd123541d5ab9eb12d9812996fd7"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "ee78d0bd5ee74cf59cf8f8f0915510871c3df9d0724cb250aeb71cbde230a980"
    sha256                               arm64_ventura:  "5275873b696d05421547d5cb9597471e37e0ea9129beb9398b53a2a9925d9f63"
    sha256                               arm64_monterey: "c64e77d9a023cd11eecae9e4c1f89290c6a02ea198fa5717747a1031b4fba821"
    sha256                               sonoma:         "1192344d139c4d2334022ab26d1d4ef9a1e16fac31951076e52643e542cb6845"
    sha256                               ventura:        "d1c021b09698d69a9ff7eaa4d82b29b4844b14ef2398744cd8b0c089dde0bdda"
    sha256                               monterey:       "980cbe155d13ed385864e4bb1723c89ec9a218ee48e134ff58858982c52c8d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae821aad2b0686ebc68f712bdd55ac3a5e1227942e2d8da1872a02221495ffab"
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