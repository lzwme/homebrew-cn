class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.30.1.tgz"
  sha256 "e2010c27a7c743246690e88ef3560522daa04175bb81b1dec82db53e0d0985cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b04237215b0bca74253ada4d7316c9458debe048d6dd45ad085df76202ffb295"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sf-mcp-server --version 2>&1")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/sf-mcp-server --orgs DEFAULT_TARGET_ORG --toolsets all 2>&1", json, 0)
    assert_match "The username or alias for the Salesforce org to run this tool against", output
  end
end