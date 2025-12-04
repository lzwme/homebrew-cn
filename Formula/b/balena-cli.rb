class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.4.tgz"
  sha256 "f9ffca02a7d30e3ef6ace376c938ae59b3cac7ed2c2e0f22860e9ef0c7904b6c"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbd8e58976eceec179d7b1776e0e1d35b3afd79322b8b0075848cabd08ee5e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cceb1fe9bebb7a23a79ac7122f9fb6a5f4a7a2fcbe533cb41cf99413c279fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cceb1fe9bebb7a23a79ac7122f9fb6a5f4a7a2fcbe533cb41cf99413c279fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6e48d5780f75adafd970117a20a795941c5f94518dd8007f8ca6391a326542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e2a27be1af8db2e7216f27f66392dfb28bdb05b160b74326c65da934b30df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3dc6636cb8b0beba1e3f4770a626f456fb5b717ac58aaaf9f9f3150aa0e2204"
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

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end