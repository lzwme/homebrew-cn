class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.2.1.tgz"
  sha256 "5e4e6123f25c25babbfd94a4d9cdaa5e1cd9881a93a712e64061b304c6fa49f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bf20bc92e15c1dbde21faef8b7fc285e2e35072ae413418b3f1c5e546b2ee4b"
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