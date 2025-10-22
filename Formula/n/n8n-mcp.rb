class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.6.tgz"
  sha256 "15b2482f513d7c6465857b30551fc7d43299b1dae89f302f2c1004acefb1e3e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d3d2066a18ad6aaabd2c29aa4ac9173789d564cbe71d704d1b3e206761b5cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c787e5c1437005fbc436d821c5ca263280d52cc6f5318aab7776aa7be07e8f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df31538ba4eb46f3a639ea273f001ce6937ac918ca267d63d34872db7990656e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf78ba5ecbedeb95035b38fc8c65e3fc4815db2ba6b157807a6ba92d3686f9d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c896692be351f218c78ea1e5ae247e92c79cefe5e7e94ced03a6688da4ede392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2571ecf3e6d93b9492bfcd3704ccf0bcdf7393bde947934b6cdbbf183e00667"
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