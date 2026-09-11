class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.23.2.tgz"
  sha256 "1e3367a2382d57b5460ed7bffc2c37c58c622abb14aaaa51143c970aeea065b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66bd3612dea7300052044188fef831cf02067fdf0854fd2d34b045f76cfd2d9b"
    sha256 cellar: :any, arm64_sequoia: "66bd3612dea7300052044188fef831cf02067fdf0854fd2d34b045f76cfd2d9b"
    sha256 cellar: :any, arm64_sonoma:  "66bd3612dea7300052044188fef831cf02067fdf0854fd2d34b045f76cfd2d9b"
    sha256 cellar: :any, arm64_linux:   "338a30f5523a5845bbaeeb7c6fbddf2ca07a7eda5c8e6287fbb51c106694aee0"
    sha256 cellar: :any, x86_64_linux:  "e66b207afd9e6f3a7f4c00a3cd761ca3b8aec8187651c09662f847e0b27b8f15"
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