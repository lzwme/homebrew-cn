class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.10.tgz"
  sha256 "c343a54532c2776af1e8433b4ef4a9600b8295c2ce698ff8eba12d4085fe6197"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "10d09e47ac144278b4c2db34a8def31cccdf3322c9da13945e5d206cc7589ae9"
    sha256                               arm64_sequoia: "eac20c83203d9ad6e2ce47c0d338ce751d04ad8fd3527e6b58ec6263fda606f0"
    sha256                               arm64_sonoma:  "24cf4a90187f8c2e4ca5a8e37432e7bd5704db4dfeb847e208f6dd5d4f0bc14a"
    sha256                               sonoma:        "4766c0f8e5eb0adf9dde59d19835bcdd68b2476420607467201c1a913506db3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5393fbc513c19252d7316d4ff75a2951bbb161ec9fc2f45bc4d797af471d18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28f6e42729c22dc3fbdf89a3672fc574161cee8a560d23f3ee40adad5f92ab1"
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