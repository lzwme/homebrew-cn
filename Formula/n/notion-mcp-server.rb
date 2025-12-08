class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-1.9.1.tgz"
  sha256 "64d941e1d43cb0cab4030daa25390e10c4f0957290f0636e0ab779e3ef62621b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec9a16c737e26afa49050cdd71eaec6f64cf58eaf9efc7eff2ac3bbd35bb0262"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion database", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end