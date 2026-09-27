class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.6.tgz"
  sha256 "9f0e7ba70009cc0a5133208cf8edc21f26eef211e9d14d0d3f497cd42a9e31f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fee0d7693d14afbfe7580ad7d1dbef085baf5375e2db0675a372936d5fd9743e"
    sha256 cellar: :any, arm64_tahoe:       "fee0d7693d14afbfe7580ad7d1dbef085baf5375e2db0675a372936d5fd9743e"
    sha256 cellar: :any, arm64_sequoia:     "fee0d7693d14afbfe7580ad7d1dbef085baf5375e2db0675a372936d5fd9743e"
    sha256 cellar: :any, arm64_linux:       "c412cf3b4732f41d756f0d8e602259cb999d127e52f08028a490f4a18a27c6a1"
    sha256 cellar: :any, x86_64_linux:      "3b75c614505a9043e37f9acbd212f61fce8c11f256326337dffffc3707a8c4e5"
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