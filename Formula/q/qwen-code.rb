class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.9.tgz"
  sha256 "752fb94a3ad8f3a0a5a018297b0525740088dfafdb0ea91001334157db1ea882"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6731bb13ac7f80e2acca5c4d0122ca19457ee1d3e7910cb4e02a5387a504a24b"
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