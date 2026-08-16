class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.12.tgz"
  sha256 "44cd390a551d5342c82c7e16dd2cb6c82eca860aa4ee89b5e8d87ee1e0b151c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbcb3e155d31b69f449cfeaf8d408ce8d190641ef7645ca2be2c390f982c9350"
    sha256 cellar: :any, arm64_sequoia: "dbcb3e155d31b69f449cfeaf8d408ce8d190641ef7645ca2be2c390f982c9350"
    sha256 cellar: :any, arm64_sonoma:  "dbcb3e155d31b69f449cfeaf8d408ce8d190641ef7645ca2be2c390f982c9350"
    sha256 cellar: :any, sonoma:        "1bdda885ad782cd735ec7480f2ba6941bd5f05f6402323a60a6101830652eabf"
    sha256 cellar: :any, arm64_linux:   "4d8eea5cbf78c7e799ada450c7c3ffa18b2e3c409efc82e15d57c4b44aa832f9"
    sha256 cellar: :any, x86_64_linux:  "af2ebbc410966c80930af08e6b575f5d115e6a38288dccb45f1ab1ec22ef6557"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end