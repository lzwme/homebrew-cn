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
    sha256                               arm64_ventura:  "82eba0cd3ec71a92ae3d3c8d501569c74eb8ba83662585e7107f3ffdbfa7e4a2"
    sha256                               arm64_monterey: "27d0caa8e530c56f1fe485d31fda3ec6df613a75a5a09911387edcff990ff009"
    sha256                               arm64_big_sur:  "c08e043e14b8ead9accfa5d2118c235576ac8841c49eb62057a55f8801e2da62"
    sha256                               ventura:        "7b76a18a8dcf4117f7cd055ab4864ad3ffe1c091201df9958b5703478cb2748b"
    sha256                               monterey:       "3939d18e262f2720924d9892d612ff3a7a12ffea7d757999e5500bfa538bda3f"
    sha256                               big_sur:        "b2cec1146cfc384fece26b4cd60aa4e980c7d4ca496f591bb62333c319841226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a943af33bafd19f7713aed0f000a2fb5850242b09cc51536d9ea909ce02238"
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