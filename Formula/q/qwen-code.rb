class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.1.tgz"
  sha256 "3c683a90a35d2d6e382ec2b964558d2c15310442703e5d57eb5013ae37569d1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2656fabbd69631dfcb1e52476a82bded999f20cc8f877a7cf94689e1ae7ee2eb"
    sha256 cellar: :any, arm64_tahoe:       "2656fabbd69631dfcb1e52476a82bded999f20cc8f877a7cf94689e1ae7ee2eb"
    sha256 cellar: :any, arm64_sequoia:     "2656fabbd69631dfcb1e52476a82bded999f20cc8f877a7cf94689e1ae7ee2eb"
    sha256 cellar: :any, arm64_linux:       "f7e749d2b2f43703646661ef882cf53dd5270f8ab273a4b3e768ed34cd3c36ca"
    sha256 cellar: :any, x86_64_linux:      "47c9acb0d1ae4385f2c9e5620e5cc9f8a10e4f8c2a215208ce94ceeba5bd28af"
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