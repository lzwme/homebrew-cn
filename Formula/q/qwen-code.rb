class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.8.tgz"
  sha256 "4c6bd7322cc9d757682ace232d38dd9782bbc17c0c2731f48b587a19c4a1566b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e2fba36805e1c0c2d48cba719fc7995c44efe368b78264adba7a41ba94a7601"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end