class AirtableMcpServer < Formula
  desc "MCP Server for Airtable"
  homepage "https://github.com/domdomegg/airtable-mcp-server"
  url "https://registry.npmjs.org/airtable-mcp-server/-/airtable-mcp-server-1.12.0.tgz"
  sha256 "50b85d58242da94bde3930d118d077f9bb94af065ac8796a34baca9b56d4bad0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9a723b48f23d5c9cd72cfb2096210b756c48be91ef5af544af62b05700ab94e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["AIRTABLE_API_KEY"] = "pat123.abc123"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/airtable-mcp-server 2>&1", json, 0)
    assert_match "The name or ID of a view in the table", output
  end
end