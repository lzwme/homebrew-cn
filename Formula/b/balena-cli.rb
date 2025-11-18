class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-23.0.0.tgz"
  sha256 "381fd87be41b8b89bf3372d7dd122a9df64d344e3dc7e7b878eded909f9d103f"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "ca251783450e5b9f9a3716fbbe2febd41df7e4056bb73f7528074c3ad463ef43"
    sha256                               arm64_sequoia: "910c2b817f69c27ce3a0d94d68ae163455ae0820a7a07e0d67e79e616cd84c9d"
    sha256                               arm64_sonoma:  "06882fe278afa6c3cc262ed16d689f25f4a9c7dde6816bf20977fb82d6c348fe"
    sha256                               sonoma:        "51fcaf6f535f5e682d7289d993e1f7526976e185a9ac24e4e2833f117ec326d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "264b4fb963140e89385e1f8570ff2197e6e7924ee163cd43824057726c45a2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ea04026215ace765408163db3e15a530ca2d4b861eee2c6635aab5d3644c2b"
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