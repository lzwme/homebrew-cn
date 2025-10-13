class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.1.tgz"
  sha256 "1fe1bddacfab07e57616b5ae0119437a98008f2fe55c172a92765f869e597e85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81b2498c770d7ddbb2b0064089a736a31972daba6e8fbb0669d62ecd53f25b24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a7fa62a708abb492f04ee4e854b01584dd71ab35b906e6aff507bf467f5188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7188087e0527b812c1a5081788993f52f4bb3a3e958566165b2d2fe394ae1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a2ee661fea32dd0189a9b0b889fa0f8ead799301beb32a05e9f7a0c51e4ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27f81ae1de1112f6ac6441fdfeb45d29ef38942a31d797f9f73a5822333d2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4213f94e6ade85f92fdeff52fd136a2f056e69bf20ba1a25d5a658e34eb0c4"
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