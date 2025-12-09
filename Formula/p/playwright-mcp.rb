class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.51.tgz"
  sha256 "ca4835b8745c75ee380ce403ee8d1c10f7517873170071a513ef739c99a39e82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c84502081e05226de2c6f2cb0aa2b5c16a73f94e28e01627271dd1bb001c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0327823f85b9fe217429691224b2fc39579b36b117bf8a1c7303b2d1ad84c0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0327823f85b9fe217429691224b2fc39579b36b117bf8a1c7303b2d1ad84c0b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ea1482e33add9c24ae98dfbb671bc98c52c447087f47651d8e3e42964982224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae8cb43b07a3c8f634b2bb82ded1e0f251e17ecb7b12fad4f8291ee8a7c8f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae8cb43b07a3c8f634b2bb82ded1e0f251e17ecb7b12fad4f8291ee8a7c8f47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@playwright/mcp/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-playwright --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"mcp-server-playwright", json, 0)
  end
end