class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.8.tgz"
  sha256 "796bc1a8505d56da90c3b3823d227fec57b6495bab4aa79d19091fb13d6572ff"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4ad74fe715816a0c8281045e07914bcb08d20d2a35de135de9f245a45a6d4f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d67e13325efdd612e1be252755a88527870939f88a8cc4764d677c2be90b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd1e1b730a42333f3744bede3cfaa0da64864f1917310ca8197ccad504b5850"
    sha256 cellar: :any_skip_relocation, sonoma:        "041f8d18aa32ada6510249da8426b9c6bc0c0d373575b103490b57950848bb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "861623882f1d81668c8899ea8538ee5616ce04f998870cef0d2ee476c3397e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c63267009b8867be30b1c04fe4dabe8f2b33a033b43ce371a124f3ef23875a"
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