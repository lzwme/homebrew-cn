class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.4.tgz"
  sha256 "40107e4f3c78c462efe46899c6c92439516dce75a0155c00b9a10b9966859a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "70a2fa9e26a86ecd3392f013ae1a29deb5993fdb78051498714e8400b144738a"
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