class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.2.0.tgz"
  sha256 "e00379a4619d47d7a91476b28fbaf8975c3ccec5af1ab288ced717a359997e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "437775f82b31d08d89305385e5317e42195792cbc2d74e2882aa8a89ee86283b"
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