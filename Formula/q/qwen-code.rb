class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.9.tgz"
  sha256 "0ef3949a1c5586573516617f97031e83292acca3bf74678b3bdf0d253f9d4179"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a57c631bf93fbde08d26314dcbb9aff2920145fca66e4ba99683f4430098c907"
    sha256 cellar: :any, arm64_sequoia: "a57c631bf93fbde08d26314dcbb9aff2920145fca66e4ba99683f4430098c907"
    sha256 cellar: :any, arm64_sonoma:  "a57c631bf93fbde08d26314dcbb9aff2920145fca66e4ba99683f4430098c907"
    sha256 cellar: :any, sonoma:        "54519890cf183393b95082d1807075f59d196e7dbcf800f4a5a126b67c6df264"
    sha256 cellar: :any, arm64_linux:   "16a88f8015d5882b8959f3c4a0ce53a1354fc167d74e25aa02972b473627abcd"
    sha256 cellar: :any, x86_64_linux:  "7624f45d2f9dea815f27d5c7d0312b43cf351cb125fcda96d09ddd2d98b476a6"
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