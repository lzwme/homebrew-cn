class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.0.0.tgz"
  sha256 "c27a570c86f2f347fec40d05cd62f3a58592c47fb272d106e6fa9c698b7553cb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d543fd9984f9b5593fd36f4d524179868db149729d1ced9576e0b3055dbfd1d"
    sha256 cellar: :any,                 arm64_sequoia: "6b553ae53af94e8b987141fc093e59e04856cc88e5a7016693c4a73996c0fc34"
    sha256 cellar: :any,                 arm64_sonoma:  "6b553ae53af94e8b987141fc093e59e04856cc88e5a7016693c4a73996c0fc34"
    sha256 cellar: :any,                 sonoma:        "39f30176c9f28c10c4d7f319f20d5219a1794797d331d482d4a1fe68ff9e67b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f25f5ef47ece845b0022842bed58b980ea8c45c7bf9b8e0b52edaa2580f4db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f001beb1880a69424fd3d87ed80e304afce5649b78b57daa441c142fa03aac67"
  end

  depends_on "node"

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
    modules = %w[
      bare-fs
      bare-os
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end