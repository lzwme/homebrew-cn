class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.4.tgz"
  sha256 "c23618fda31a1c09ce153b1b2a6bd1c90aab806f8c16591276552f5324473f2f"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c6ef3ed0dd00e374efa18a702f1949a1fc5826730e5f721eeecf59f97663a3b2"
    sha256 cellar: :any, arm64_sequoia: "c6ef3ed0dd00e374efa18a702f1949a1fc5826730e5f721eeecf59f97663a3b2"
    sha256 cellar: :any, arm64_sonoma:  "c6ef3ed0dd00e374efa18a702f1949a1fc5826730e5f721eeecf59f97663a3b2"
    sha256 cellar: :any, sonoma:        "b704e4505240fd7de019cc130447aae748cc6e6a101b2f66c72eb83bedfed220"
    sha256 cellar: :any, arm64_linux:   "a84f5d88e32d3128c1fddd386db8c3b374e2f3b936e8a69fa11730e56cd9900e"
    sha256 cellar: :any, x86_64_linux:  "aeab38b4778c9b88d31818ca17c1b7325de1ca0bff6eed4dd37c06088a99907d"
  end

  depends_on "go" => :build
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

    # Build dependency @balena/compose-parser from vendored Go source
    compose_parser = libexec/"lib/node_modules/balena-cli/node_modules/@balena/compose-parser"
    cd compose_parser do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-C", "lib", *std_go_args(output: "../bin/balena-compose-parser")
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    modules = %w[
      bare-fs
      bare-os
      bare-path
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