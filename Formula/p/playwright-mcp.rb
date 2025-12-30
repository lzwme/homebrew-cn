class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.54.tgz"
  sha256 "7cf3130444d3046842e20dece8d9eb5fc6d0e1a30b66d5d3773a1e0b45f3dd4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0afc821a878928c58c3047c36fa59822039bff718de88268c9953b1f0da1664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b94b8d0563e1a0078fe964c31f7e86ab9889fb48ff0d658642ca59905549ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b94b8d0563e1a0078fe964c31f7e86ab9889fb48ff0d658642ca59905549ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6b5ac46bde44d9803665d4bf487c3de61eb62c80b40196728c336078d316ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e391958c919fe60ffd22f63dbd536584c0440fcc16bc3e7d3096b38a38b9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e391958c919fe60ffd22f63dbd536584c0440fcc16bc3e7d3096b38a38b9c2"
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