class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.7.tgz"
  sha256 "64cf502b48e2f6b882dcc868bb163c77fff1068fea07722c37093f2a90608c1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ff35285492ca7ca158d1566df205c9b4d3e72ab54bfd600747762f837ec615e"
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