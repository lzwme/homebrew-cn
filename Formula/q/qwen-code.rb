class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.0.tgz"
  sha256 "16dccd12a9ba433d0e7aa9a18637d2e340bf1a2a4ad01f0f3ca1eb5a69e5f2e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "35a4e95973f388d3e2d55b6e9cf33635f6eaa13bfdf0bb79584354b5e66597ca"
    sha256 cellar: :any, arm64_tahoe:       "35a4e95973f388d3e2d55b6e9cf33635f6eaa13bfdf0bb79584354b5e66597ca"
    sha256 cellar: :any, arm64_sequoia:     "35a4e95973f388d3e2d55b6e9cf33635f6eaa13bfdf0bb79584354b5e66597ca"
    sha256 cellar: :any, arm64_linux:       "720cd03842cd319774a83da14d116ed30d71f95f6ce2cb946571b2b1297989f4"
    sha256 cellar: :any, x86_64_linux:      "9234355ee49052d5cbeb8c2756102d5ef3915522fc4feb05de296eb6f759e56c"
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