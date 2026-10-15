class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.4.1.tgz"
  sha256 "7fc18bf65cfc8d019082cd3a4fdf2e1cc427acb51ccd98cb2b3fe390b68e211e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "534bf249cfac7ee336128b5536d045587989733100acf009caaec501780e1fbb"
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