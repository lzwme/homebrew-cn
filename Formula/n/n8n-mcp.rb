class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.14.tgz"
  sha256 "89ab950d9afa86b43d9c201e07ace7994381fce6915b4be901a943857839d203"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c4694ae8c1d0dd6818ef490d81f09d31435a8c34132fe7ae66ac165911dae7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aafa1fe09aaab76e6547ffbab401c39547016802ee39fc1bf7c433def6f3913b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1e20233b82d71c646d333226d3eb7d5ef3a0271bcc2db160d91b7a6e50f2c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "491d461f90897d7924320a66a5399385dcf123382f006d73f20028f4886d91a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50a7e21c64a40f5329e5a39fee67bf8ecdacecb5945cca1534d57b00c196e7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe47aa868c7e2dbbe270b88b603a7083bd915968ce9f1f95a1d8a9e32eec61d7"
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