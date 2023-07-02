require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.3.tgz"
  sha256 "e7d46c0920a6f3785776c1e0b5427dd6082d504931db9c7eb284653962a989f1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "88015b2ac0a94b93b66703b17e72f5cb22fa587a0df085a1223c7c46032f5afb"
    sha256                               arm64_monterey: "7e302b855ebc3c318eefdab78ca049727a5021e711db4c3dd6cc2dd30c5afbaa"
    sha256                               arm64_big_sur:  "7acece2b75e2eed8bacf10b6019f56a0807ec9793396fcd912afe0520e2ddde1"
    sha256                               ventura:        "6958b591dc87cdf4d5fb624be3cbcaaa2bb195267177a31e3926187526175d92"
    sha256                               monterey:       "b25b8083afa34f70fc1741a08f9e10aee227b3bbb6a7ba3c22b839c953e533b9"
    sha256                               big_sur:        "0fcd8badcc18f829091583aaf0162d16a25a8c5e349b657866f80911682165e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59c0f2aa64296f4df5a76542bf044958e419c3d77368662d5bc51d8da87de9c"
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