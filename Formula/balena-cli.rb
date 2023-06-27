require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.0.tgz"
  sha256 "fed7ed5d31ee0dceaf24934dbc9623580c441c45a2989f8d42c670051685bff7"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "230866e32a651c4853b676dfe82b87402cbe1ccee3f22c7d7d8161b1b61114a8"
    sha256                               arm64_monterey: "7926abd32da52c9e0dfd3cc949f69cc35eb7e04035f610e53cdd1642ba68b389"
    sha256                               arm64_big_sur:  "c8f620b59342d2382a51ac38728c83a14bafc9e05dd4e2817a515d0942ef6770"
    sha256                               ventura:        "d08e9b59c87a0f76b84fecd413d8fb924db8586f79f8d2724ed3a3298e229e0e"
    sha256                               monterey:       "37fb42559d0e650dea92fa2f5ac4fbdc2121443df300844952ca25f8736ec699"
    sha256                               big_sur:        "df4b57ed46d7389c66b55bebc3a0dd16422ea124271755fc91a8ffad06e3094b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98cc3d96e4e7f99865be2e7ecf51057d929838f5daf87b76ea81f529d9e7e52"
  end

  depends_on "node@16"

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
    system Formula["node@16"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@16"].opt_bin}:${PATH}"

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