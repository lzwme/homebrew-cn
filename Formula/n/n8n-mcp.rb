class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.7.tgz"
  sha256 "132977a4823c26e421196fd97fff31e251aea7cce365c79b6333f31ca6ecbd0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07502e48bb97714e1442ff3618b48d1fa64520300a5d840eb2eda8eb453c2cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc793974874c6f55f6c1a9aa1107da08418bf0ed3343db7de0540008ed9d99b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7674fcb2d1725b47f87ae2efc4d1f27c4fb5ce54484274421d0ef8b86e03a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "408fc8d9bd65fe19f66407a3dd9c9b46a9fa72069d895beb8a94111c8698fc6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd16e7dea16af9ee78970e872df61f4d158bd1fdc6abfcf7fdd6c5dedcb7eeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3007b1de137beaa93ef528f68b107eca4119fe4086e2a12d3b7f5164782ec79f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end