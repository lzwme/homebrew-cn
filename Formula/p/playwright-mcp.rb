class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.81.tgz"
  sha256 "4289f7d5fe256b69db0e49050148b175af80fcf8caba814ec6b7b64f5f64161b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "40ea5d498d2f4b8f67a163c91f22efcca894fe3e6fea76eead29bdfba294b8f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"playwright-mcp", json, 0)
  end
end