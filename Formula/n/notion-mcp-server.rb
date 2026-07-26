class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.5.0.tgz"
  sha256 "8e408c9fe55a7d32de4b5c124b188446ebc64808c34628b6f90714ac5d120245"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08c777b0dba0feaa0f07d346607d455ca980d0e5819261d9e4f4de625a310711"
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