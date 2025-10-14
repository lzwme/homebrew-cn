class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.12.tgz"
  sha256 "5ffaa9f6877e66d9f94641b09bcca173c162dc00de1bda08ad52e3fae2161c75"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "dfd665af9b244b351c123b9645b821e493c17d8b35d4eeff3464e119edeba09a"
    sha256                               arm64_sequoia: "dd750e0ca6e78f873c87e4a34ed6dce91f8f03eb93c6bb08d6f0b1305eba72b6"
    sha256                               arm64_sonoma:  "8196405efce150cdb7f03b7210cd8f6a7dd4f77d15f19d50d3453959f4f41a4a"
    sha256                               sonoma:        "bfdf2935b27b1195b5f0359fb06b2e1b3d858cf9925a7c81b6e813bd2fe3a6dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15bc570c0f9a7eb3985c02fbaf2365c78a83375cfb79291eb87a1d2b1f17a641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ada8a2482e6b74eac1dafa9f1e3cebb15a627dd4b2764f2a6038d0f5eb6acc4"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

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