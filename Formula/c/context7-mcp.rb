class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.6.tgz"
  sha256 "5932210e45dcc4988e31244051f61f031491b41f0b8f10003ad0b2704ce304a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb2d61d4cc4ff1461d513e333eba60879877a9bcf89f8ceb4b7422fd43b33703"
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