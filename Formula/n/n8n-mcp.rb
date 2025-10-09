class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.1.tgz"
  sha256 "130710d203ded326c1b3f7970227cd7b4e605ed29bfed11e62047f2a0b77e8d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8457a0141c896e2c482aa5185abfd347438a61db78c6285a7b37f26c39acdf13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e0af98e46790ffb59bd9311f1096acf540647e5975d8726757c16ee25ff0b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640d9f7f6215d6049929a94a2ea44bb2d7e7717ed6c627ba43659d0314ae8164"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a124fddc9d778cb933fdae7004bac46bbbdee527ac709d2e0ad4909028ade2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3259fb41d6ff1283fa6b764f3e7bf4147e17c35d7783f249d540f0d6d66356cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f37e290ce24779e8a93bea29c0ef698daf12cb2d75680ea34a7d56865261024"
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