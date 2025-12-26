class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.53.tgz"
  sha256 "592adf3a0609745d1825fffbb3d627ee8500fa344ac3dc6e998c2f0e80f8bf7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef207b3ae964ff4e3dc7359e4e69d0f107d6e08681753548975b332fdb5755f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e244b39131aa6b08aeef5013562dd134db10905b13a6165b34cbb83b51ec61fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e244b39131aa6b08aeef5013562dd134db10905b13a6165b34cbb83b51ec61fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7172767dc26e457e83bbcb5466d95b5da7c856890c32b52cc3344676e76b9d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7811ad480ed82b9e79c75aee980cc4542712fbb832135ffb1efc13c8a94f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7811ad480ed82b9e79c75aee980cc4542712fbb832135ffb1efc13c8a94f3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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