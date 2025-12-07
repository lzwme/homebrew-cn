class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.50.tgz"
  sha256 "3e844e8f089e4a528c66bab9e1ada68f02bf5cfe7d7cfd9f64d11c026a54283b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a8ae85742e7dd0f3a67ebb69ea5ec0be1948badcdb1fe30a4d72b83c12108c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b23a213ab31ab72da55c5e334eeeb9875e4751f08c5f9623ea81b83914174b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b23a213ab31ab72da55c5e334eeeb9875e4751f08c5f9623ea81b83914174b5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf47bdefc2ef095a75d3bc5d28872b60b860e6151554cbb7eb90f05e5a495bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07421e3915c5f9e0994282b43733e1e99a4cf7b5132d34d79b15c919cf6c21e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07421e3915c5f9e0994282b43733e1e99a4cf7b5132d34d79b15c919cf6c21e9"
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