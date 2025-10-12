class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.10.tgz"
  sha256 "294c308508881288810fac6b28504bf392bc28d641f5a33e068608a688cd0995"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e56c97fa0bdc2ad23101680d668ee91c142e3e9619501b035d03c5da07ec571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8313854efc05574168867ef7176ba2e14ac363dea17ee985f37f0e322168bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f715534d255181ef465db5efbbffd38027dd8ad1f8f03797f03e669d0dec8c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b385fb52a26818e0950bd0ef9af51bc4eceb4013ac6915b578aa55183bce9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4839fc5b133b9d21b73f37030e9ecdb73ceb27b3edee6389faab304f52d3ac43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "905f85f1c2ee63bcc30a01feea3175b3126b065aee72523d39ddcbe54d8950cc"
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