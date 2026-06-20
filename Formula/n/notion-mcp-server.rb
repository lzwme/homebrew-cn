class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.4.0.tgz"
  sha256 "27fd3bf154436c2bebd9b63bcbcd47010168b0b85d0292afcf53221462dc3cb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c786acfdf61b953558a2a3aacd4972132062e03f2a1226537b153ba82f8ef65"
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