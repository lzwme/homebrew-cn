class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.0.tgz"
  sha256 "d90c531dd60671b6ca547844fd2a8ca74a6b6789f510d2917f5a7c066e39a0a2"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "249d7f385e5dd5008db0e7c9087de7116d6263578652d83a713dc2cefda16717"
    sha256 cellar: :any, arm64_sequoia: "249d7f385e5dd5008db0e7c9087de7116d6263578652d83a713dc2cefda16717"
    sha256 cellar: :any, arm64_sonoma:  "249d7f385e5dd5008db0e7c9087de7116d6263578652d83a713dc2cefda16717"
    sha256 cellar: :any, sonoma:        "76efcc713840fa18f3a5f14ec5bcf8b3f5b96391f77ba2f8c58d9ba6d658f256"
    sha256 cellar: :any, arm64_linux:   "4d61d27aff229e41a8e7e979f993ed18ead498ae21951a6deef8d1212c2bdf32"
    sha256 cellar: :any, x86_64_linux:  "b1714d5a784b0870dd6401c7564f9d61bd50addec4409ca5346ba01a3110eb87"
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