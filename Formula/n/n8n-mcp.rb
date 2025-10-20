class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.3.tgz"
  sha256 "d97c99cb151903cd9464d43a860b66dbdefb9bb3d24d92c9343a5ac3db6214db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6258a55f27b3a0e707b24afc08f0271f56433f7c02ffacf295a2631b8f6ab90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb5acc8a95d9f479723009db25ddd269aec2304419a668c60e0b35ce01d1f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf7d6023c9708d238f3521ad4861c11eaa4328321dee1bff9ed17fc4bb74048"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf563a3dc22e992e29325f2cb57274cbf7f10fd21f6a95942b9bde7afb5eba33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36fc17ee2fc5d6df48d59133587021eccb6dfab8e62838fbfc63e1e99a7f5ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1785552c7a8fc9c603e0f50915d6d2e5d7a975b29507af26dbc80c881d51c3"
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