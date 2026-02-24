class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.1.2.tgz"
  sha256 "a6620e39d906bd8cd28bb36c5d7cb92fc0fb4cbc84cdbe4deff009393f2c8778"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fbdaa64a9bff712e87fc226a8fc45023c60ad64204b6b01637587098a2ac596"
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