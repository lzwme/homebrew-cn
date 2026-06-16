class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-3.2.1.tgz"
  sha256 "97e68a549522e457e55e1be0e8f7198bdc4e785ee1846cbf1e116b6102d9d708"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90006b74da92dd1b53369facf79d966f5c150d0db58e13be225f4c7390e93a62"
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
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end