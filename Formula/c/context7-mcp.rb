class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-3.2.5.tgz"
  sha256 "eb801dc8b6f29b315481f131fbf5258a99292fbf3325b0ef2ca2a5ac524c93cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02d6ad939566294b00a5a192c84980db8ed412927d4219ea716dd9efd1949e5e"
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