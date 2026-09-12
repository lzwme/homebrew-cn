class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.23.3.tgz"
  sha256 "1f791a136e326f79f317784d1244c79b020a0058eb9458dcf6e1594ae67fb5e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f5b5e8ce109c740ed956f3c6d4106538760e8627ab5b11a2f8b26b7285705ed9"
    sha256 cellar: :any, arm64_tahoe:       "f5b5e8ce109c740ed956f3c6d4106538760e8627ab5b11a2f8b26b7285705ed9"
    sha256 cellar: :any, arm64_sequoia:     "f5b5e8ce109c740ed956f3c6d4106538760e8627ab5b11a2f8b26b7285705ed9"
    sha256 cellar: :any, arm64_linux:       "410e095163d6440b7015a3c0f0d25fd4c8146d9bfb8b19900660e9b0567b363b"
    sha256 cellar: :any, x86_64_linux:      "fd366961f75321e2a1ce2b7be8b0425d00e76194953364acf9a749b70bb23ac6"
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