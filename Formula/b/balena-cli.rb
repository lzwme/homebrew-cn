class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.2.3.tgz"
  sha256 "667c890c223e72eeab25ecabdda6fc11c0c4d1ea074c515bf27074c3de92dc13"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b41bb0595eb19fc9bdb220c881c14c4f26ae61e227d73d502c9618d7dd9e7eff"
    sha256 cellar: :any, arm64_sequoia: "b41bb0595eb19fc9bdb220c881c14c4f26ae61e227d73d502c9618d7dd9e7eff"
    sha256 cellar: :any, arm64_sonoma:  "b41bb0595eb19fc9bdb220c881c14c4f26ae61e227d73d502c9618d7dd9e7eff"
    sha256 cellar: :any, sonoma:        "904a7323d89f32864edf6caef6eb4f447b7ffca8fc43d6b0d107b89486990d41"
    sha256 cellar: :any, arm64_linux:   "2114f3f715b970c4efd38def99a31533627fe26fd0d6ae2f25bc5b7bf203225b"
    sha256 cellar: :any, x86_64_linux:  "b7298e5df90c4e5bac5e88118543df79ece3be38357b2f1eb2a3df4e25aedf49"
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