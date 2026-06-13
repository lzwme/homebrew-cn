class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-3.2.0.tgz"
  sha256 "229f69564c955a2f0dca1a6e44d2ff727391bb04419cb2788ff5baa9a1bf05ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83c564bd1687cc039a820fd7046cd8196689aba694e96fa42e07339a432bd082"
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