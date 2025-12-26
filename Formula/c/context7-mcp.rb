class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.33.tgz"
  sha256 "825f1539d05ac5812826660a855a334acb0dee87f01377e04cabf0ed26d8b341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7678233479bb62d5b0a97f3702068473217fff2d5de4e42c3e5c2e23afec1c4"
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
    assert_match "get-library-docs", output
  end
end