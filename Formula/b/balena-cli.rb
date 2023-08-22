require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.7.7.tgz"
  sha256 "619a7c763e023709d92af05984f916cb3855a1f39605b3143bc3a2302f328d47"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "0be87ac2de48236b61823815a4e7679a0276154be17402222cba5f644971a32a"
    sha256                               arm64_monterey: "4a718a02c1bcd1c5d1401aaad449190154b41c3188875173845bf53a65c57719"
    sha256                               arm64_big_sur:  "58ce20da53d6569b2dda7865882a41c8bec25a6b4d0564bd0c1854b93eba07e8"
    sha256                               ventura:        "9abe2449df41797bcf4e9da9a42b22c2cf124d753915f1bb9d8e83413b3b9d0d"
    sha256                               monterey:       "dcdf866e7c6063cdf8011de3b1ffad6976dd4a4a60631a759ac9e14dd24f1ee0"
    sha256                               big_sur:        "cadaf56b63af590ca4626e8e8969382014271c967c95144598c0a1048b6e6c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb8b13ec04ea45efbbb5bbfc35d5722e22eb20150b5851787d773c0239eb354"
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