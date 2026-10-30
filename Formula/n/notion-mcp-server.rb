class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.6.0.tgz"
  sha256 "47fe38dc2321b9e0ed07f267d2285d9c4faf7a5c45d9f17a64ae6570ec6332c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40c2abcdabd085b6836faf0682233a3c18d9aedd488fcc8e377499461b1495bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion data source", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end