class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.2.14.tgz"
  sha256 "8ba7ecbb212ec7d4b55cd825cece4e3bca6dd3a2820e5e7706ad4e19e8195ffb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d4b474e321f7485a0c1a3e79ad3e21c09392e098db50ce239fdc18d7472d9e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72de1e28827592054d280268e572d428fd90dcac2b84305a933f3156c95423d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72de1e28827592054d280268e572d428fd90dcac2b84305a933f3156c95423d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db5d44a7d0e42fb3f64ae60d086ee5e915a501a333806d77ad4a01331c9a82c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a074c7534c146286ac04c7e47971d145dca34c318f58409fba46b179c9d902b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba25fd77ab832669518a1c91e99d893c636c62ed2b396e355f0f750721087925"
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