class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.3.tgz"
  sha256 "43095eba4ce259bec43082bd2ceff9447dd17204eaaac8994c8d715273461780"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "0006439cd5e0cd4edd09e533f40b68173647d7d9d3a62d1eb8a47752a210e1fa"
    sha256                               arm64_sonoma:  "19fa3db2efec37833f6339884fa5af3e4a568a6b09724e95765923fd06c45611"
    sha256                               arm64_ventura: "ea5c723f280d7ba4e60d1853589c6a24a22851fbc63ee59779567731b4cee2d2"
    sha256                               sonoma:        "d8bef50a3592d20099a6abe611bd3f6fa054b0a623f5cfeed6db8b0f8b5e34dc"
    sha256                               ventura:       "bafbda5e7c087741ce79f5baa2284db6da3d15db8151e1d37b1ac055e8b93da3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3569de956c1c877fa60bd9456f662b60dcb136e6cf9feea454a7ad802e3cac15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98194bcb45391a2bfd1bf82d661e8dbc18baf55c52be3450c0a52da7a76d9894"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end