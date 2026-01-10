class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.16.tgz"
  sha256 "ce4b6c9306b988bad3853688bbca307a94464a1f03c1d4ccbe11ab133ea2a371"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc69c0f129f00c466c4934365ed84b9488276a3051d2f9c86810d7fb56ce56d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7817a8bac53c9de64e931cc297fc24d6d20afb7f8c93ea10ec72b7344c1a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7817a8bac53c9de64e931cc297fc24d6d20afb7f8c93ea10ec72b7344c1a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc36c0c0c13f7e01c5e69509e9ee9b23fbc4e817c5df8746f1fd1966876c5c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1991cee97bd5d4817887be32b3a5a3d2e000dd6a71cba57b3e2c46e20b47e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39fee1dfb729785c602b37fe7f15eacd470760436aef5d91ab7d2ec9f3c88009"
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
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
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