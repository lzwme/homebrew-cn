class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.52.tgz"
  sha256 "64cd4cf4357322ddb107f364330b5f121b4f4eecbf09e0da9fb76665ef6fa3ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efd4f5809673f3458e46e2c1ceab2984d137f2f5f50395a2055fe6d28bcdc7fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d64cd7b20bcb5908cb7a30e31f7430aaf9467e9b9934b2533199cb186d282d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d64cd7b20bcb5908cb7a30e31f7430aaf9467e9b9934b2533199cb186d282d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce8b6869cc61badd3677f64aaae6bcaa48e35b295cd1794937702dc8e38dc25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b055396c39597efcb56c665a8067807247841a3304a1d419dd155fe4f49755b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b055396c39597efcb56c665a8067807247841a3304a1d419dd155fe4f49755b"
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