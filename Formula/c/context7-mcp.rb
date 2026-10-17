class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.4.2.tgz"
  sha256 "aaaa96e8b6fbeb63f496ef560f0dd96c6774a6a97580378d53ab63ccc5850d2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d444ec8ef7a8abd37c7f8d4b765d20777a76d28788a4729fcc4e999c6d4d2cd6"
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