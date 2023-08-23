require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.9.tgz"
  sha256 "be64269225a21270276e7c48fc771ff5708576390ce481c28de94c34c8510fc7"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "304745062e3b588e98edd1bc7851050717455d60f905bcaaf9c3ee210f33e2e3"
    sha256                               arm64_monterey: "b5cbe2ef2cf439744724e200b73e630add991448ab4ab582d567c602cc0bd7ed"
    sha256                               arm64_big_sur:  "db9b9983579a293ae6e70da04202c55a9129e16983a621611db93a39e8cb8c48"
    sha256                               ventura:        "0510fa8adc0018dad482387b6ca93b3816ea4eac21038663e6a896fdb114a303"
    sha256                               monterey:       "f995ff09c7228fbb3183fff83cc0ad9ea60d63797d4a1441815d3c5b4ffd5600"
    sha256                               big_sur:        "76adb6cfea3acb18c7070e780ad19b7b0f0a0a25656d303adafd1f3035ef0859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823c8a3b9964fd6623a6915ac66fbb27f1e8d06d95d5aa8a5d3fc749bb5e2e63"
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