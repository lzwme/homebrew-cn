require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.2.0.tgz"
  sha256 "84048db60da2ef9112d06cbeb251067cd59932f77782ebbbfb1c41ca1d9d1f05"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "7e5e9269087f43b5d972a05447522b84c478239f902f4e260a4febc1aea3f43d"
    sha256                               arm64_monterey: "aaa8701c604b3467db943d9cfd88e2eb741903e5d137ba026716f06a0aee5f1f"
    sha256                               arm64_big_sur:  "7a9b607d5175b120e71dffb71b73914d2398db1e3148c13fbf22162423188741"
    sha256                               ventura:        "6a956e7ea01fab26ea0ff4bdc4231149a4426ec0078a3e6a9a93b244b9894f01"
    sha256                               monterey:       "9386dbd9432d3c793dd3cd5c0cdbeb7066003e328180772c60ad2fca337953e2"
    sha256                               big_sur:        "b7f0c55990af81febc9c76348a1797bec1c64546dbefe529552cda1d938eecbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09f4d7f4560b0f1ce74b936e583cf4f4b55853286cf4e83f11579adb93c4f4df"
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