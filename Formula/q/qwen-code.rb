class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.8.tgz"
  sha256 "0be4da0e3c00cb75121cfa1a6c64f6414dcc1c017656ed8ab030656cd3b5f902"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "13d2b8c79c1b8bc0b7eb6b0a522900bb26c9dc4ff46d9dc30fef386dc1b47fa8"
    sha256 cellar: :any, arm64_sequoia: "13d2b8c79c1b8bc0b7eb6b0a522900bb26c9dc4ff46d9dc30fef386dc1b47fa8"
    sha256 cellar: :any, arm64_sonoma:  "13d2b8c79c1b8bc0b7eb6b0a522900bb26c9dc4ff46d9dc30fef386dc1b47fa8"
    sha256 cellar: :any, sonoma:        "25e6e22d88b0740bfd145bf0aa8f3137a5f6b3b572d3cf3ed7c6353261c11ba8"
    sha256 cellar: :any, arm64_linux:   "1dc18983b1dd9263a2a21e23571ba5361e292493eb52e8a7d3cb102cdc05cd8c"
    sha256 cellar: :any, x86_64_linux:  "d092e79fffa649048a4ad45e9e5b243787c6c32157738fba6cfd996fdad1b509"
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