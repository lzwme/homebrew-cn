require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.5.0.tgz"
  sha256 "71908f0207065813d4648c1783c133650efe693927be357d933830792470ffc1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "70c17f81ede716b46e6d582edb6df0fbb368e96f20fde2f458612e5564465e35"
    sha256                               arm64_monterey: "678c5a78fc89765ff4e557e1aed62698d56b36c9ef5a5137fa146e3381bbc625"
    sha256                               arm64_big_sur:  "f7d5bd15a1aa37112681ccb3de604df6311eb3e1d3e29ad30e74f8be1ddef2fd"
    sha256                               ventura:        "8d9d103131a5d48c5138b5a0cba75e56e710bb72841ee36ccbec5435adb32dbb"
    sha256                               monterey:       "99c649cd99cae490664b20aef0bfb3ec7d786cddcbb92bd1bf46798bd75abe60"
    sha256                               big_sur:        "0ef07dbbdeee3da94d3c49a4ff83bfcae6acd2624ae4314d89082771ab4d271f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b091255b4c1fbf74407e970c872a3c2b9da0ffb05753806b28b253c8c2cdadd4"
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