class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.90.0.tgz"
  sha256 "c12bfd2d78abc60b3b9fe0aaeea67d53a4b8626c732ea03f758a971a4f24283f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6036a59796fc0412f3bd0006441874306314a883650f07b986b7868a2d9250e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6698665892b6fb54aac3d0c2373a71db4140b3de55979bd1f548a977faeefbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6036a59796fc0412f3bd0006441874306314a883650f07b986b7868a2d9250e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6036a59796fc0412f3bd0006441874306314a883650f07b986b7868a2d9250e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6036a59796fc0412f3bd0006441874306314a883650f07b986b7868a2d9250e0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = [
      %Q({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}),
      '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
      '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}',
    ].join("\n") + "\n"

    output = pipe_output(bin/"n8n-mcp", json, 0)
    assert_match "\"name\":\"n8n-documentation-mcp\"", output
    assert_match "\"name\":\"search_nodes\"", output
  end
end