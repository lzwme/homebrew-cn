class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.25.0.tgz"
  sha256 "afeab0c85d682f201101319ce05decf3302d7ed7fb6319baa6a592051ea1a1ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c41a17c44e250365cba8af35e1877f3dd75d35786ccbe063518774ae96ae661c"
    sha256 cellar: :any, arm64_tahoe:       "c41a17c44e250365cba8af35e1877f3dd75d35786ccbe063518774ae96ae661c"
    sha256 cellar: :any, arm64_sequoia:     "c41a17c44e250365cba8af35e1877f3dd75d35786ccbe063518774ae96ae661c"
    sha256 cellar: :any, arm64_linux:       "4b4b267ab1fb2d5faa048e5f55ae1958566bb6214984a58ac42ba07a218448c5"
    sha256 cellar: :any, x86_64_linux:      "18d0b33c573146be3043d03c1899354466516ec56520edaaa3241f8aec55e7f7"
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