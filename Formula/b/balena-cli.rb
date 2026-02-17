class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.0.0.tgz"
  sha256 "cea7eabe8e445eed943295aff3428e4216b6d776d4c136278abf9780e1130817"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d3dfeb81cb1fce8d7891e4ec2d56fdc1738d8636768f53481385a878c64b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7efcf39735dac532d50436e263358774751a0c07c58c4b9c179e06e173998afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7efcf39735dac532d50436e263358774751a0c07c58c4b9c179e06e173998afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41a8cda63fa7d32c5cfaffc71aa4d2f667bd465c2980b4e5f632f61902bff9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e55206cd2d0564ffd0506748a4c719f75846a942979cc316b0948170c5138e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310e75387805097650bc98a5b2399b956512fe4b6bc328634f14d5499c0050bd"
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