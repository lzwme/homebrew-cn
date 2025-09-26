class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.18.tgz"
  sha256 "aa8370c70e7a5e4c23f241ea5bd1327142a54c1b5b40aa58c6bb4937ff2df349"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ca314f031e800a4e062cb441d57e0d1fc000bc0a06c29e8b9fe8cb26c6da479"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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