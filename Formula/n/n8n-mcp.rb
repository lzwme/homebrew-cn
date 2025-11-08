class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.11.tgz"
  sha256 "0e8d919bbdec2d99e231ef56415d4bb30ac4cd4cac51c6937b49427a5ca3a3ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a62a6ea747ec54d370fbdccbe1d4d55f44055e9c2f1047086b040864f854ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b91386ea0bbfcb3a92a6a49211bb7dd58c521f8c90e394652327cdb0713e87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f2ad1a0ced0cf991a76872e06b7d8b7e3ccc7508d77b608ff0004ca83d6e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12a4f31467073cc93a0524e260fb7525d5848c625a92b5cfa2679a29d8162fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fea224d8365fa343c2ad3fceef7dd03e0d0a4e7f41e6a4b9514c85a466df4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e634fcee83d815aeb48d2ae39e7772e046265e5552613b2b471455dd7f850f16"
  end

  depends_on "node@22"

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