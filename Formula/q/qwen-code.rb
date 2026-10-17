class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.25.2.tgz"
  sha256 "4ff46c2e249b41cf342b14d83b31cae24b0ddd57f77bcbabfeb396241738cf25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c0b29bbb44081a768626920ed54f2c19b95e8d5c75321a21a9865abe2396464"
    sha256 cellar: :any, arm64_tahoe:       "8c0b29bbb44081a768626920ed54f2c19b95e8d5c75321a21a9865abe2396464"
    sha256 cellar: :any, arm64_sequoia:     "8c0b29bbb44081a768626920ed54f2c19b95e8d5c75321a21a9865abe2396464"
    sha256 cellar: :any, arm64_linux:       "9baab561f54ecf1a038c1b179b9fad787ef36ffda353acc2253841db8633841f"
    sha256 cellar: :any, x86_64_linux:      "a6642a7d2079218f27fcfbd555176e19142cabada33791af832bb9cd0063bd77"
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

    qwen_code.glob("vendor/landlock-run/*-linux").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}"
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