require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.2.7.tgz"
  sha256 "0f4d6c6867d3e55f7fa90070604c9c59f718ed353aad8ece1cc29a09aa9a35c7"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "28bcaee3dc0a7331c31abbe88bd7bb8f4a838d96199ff7156428bb9395d81944"
    sha256                               arm64_monterey: "fe7ed3067f0020cb8346cf2d0a60e6c4d0f873076d8ccaa458a4a37264953de7"
    sha256                               arm64_big_sur:  "2e8a921f50cbd6c5c3b7494a7e5ae5e6e9f5f5cf859a7adced0f147f946a5004"
    sha256                               ventura:        "aebd2a254395effb746916e982394237ec6b2d74dac8af6a9de8dc0acbad4558"
    sha256                               monterey:       "555e31bd0df0ffcb21e43460eb3c56d6d0060c3d10bc2389b3ffe2e6336248bc"
    sha256                               big_sur:        "45fb570fd4d5aa53d8088e6b1beb4e8af8fab5e7872fe9c161b343ccd4921a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9361e1c0ce1bfd9a729ba3bf36bd0806d56fc772a130cbcf731de28584e95e0"
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