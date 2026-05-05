class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.2.tgz"
  sha256 "5b4c89f974dbe6a95468a79d1e27c1492efe95dabd5ff0b40e3364d4eb0eb3e0"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf5f87d8b37c6168f511c956f74239616893af65ae122bfff90430428161d682"
    sha256 cellar: :any,                 arm64_sequoia: "87023b2a18a571f8c7f9cbec1e20c9a8809bd95d2ad2da3ec5f930b873a17f65"
    sha256 cellar: :any,                 arm64_sonoma:  "87023b2a18a571f8c7f9cbec1e20c9a8809bd95d2ad2da3ec5f930b873a17f65"
    sha256 cellar: :any,                 sonoma:        "322ed803f376efc3de44026a681d086cbe8b2c9164a305baee5ea86bbe3709d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db603c2f31e528b19f1f5540b73cf4266a92fe6345861ea40ccc66c9609115d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d635b4579a6f17f5cde39a16242ec10207368507d793decf4aee9b09d16b7ba"
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