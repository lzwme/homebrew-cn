class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.18.6.tgz"
  sha256 "aa8d6b5a1906e64b5e145765b7bc43e9c601564fd4f1a9a93d294797d8ceef7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2561b53295ca0239d176adaac75426cce9b55956fd67ed86ec3a814092b830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "212a0888f0e4f899532d2b0c3de1d176d52ae518165e7679896c47f9d00da669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc241ffa0c2b3f45f7a9fbf12e4a14e54eff57776645ac70d41364f6eaffa8ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f224ece2ebd08dfc935397c549dd03a04780616e8b570d8e8856acc2177b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1532272aec7e5686fa0c1c5c56820292323aba02f7f978440362802faf4e848f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ba82b3f90bf9c5ac9d98aa9b7374112525796710820a897fae085c86090295"
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