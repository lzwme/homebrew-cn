require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-17.3.0.tgz"
  sha256 "be46165ec4b96f14990ada759fcbb5333ff523b5d1dde16156cf47b3d7e3499e"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "18fd3258a0d0f8b001195c97294115f9b35e671c4254ae7ec5db4de544521d80"
    sha256                               arm64_ventura:  "ed00d6c2f6408b47277184fe802cac57c5fff310509fc73ab6f6d2a9ffb040bf"
    sha256                               arm64_monterey: "2a3c84f1d3089ea0980b813e9ca4fb808abca292e850002f86d48f63f62973bf"
    sha256                               sonoma:         "e4d2ed0305de6fa9e36be153351f3f26fd8c255cbefb197d3d7a9a645dfeef9d"
    sha256                               ventura:        "9d6619a8653dd55856e4e7ab79a8a13abc354942d854541e66f6d9356ae5d9d7"
    sha256                               monterey:       "da94756e2b88cadd3d5a873642e40c2df39b02b7c6ba53924ec11cdec27c6e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c831e75a6a0f3c3f1c24343d2f542d4c646e86f573120535d62bfb167b6ecb97"
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