class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.3.0.tgz"
  sha256 "0b08bbf437ed895b6f59132d4537683fde2a1c0545767fa65576f060fda3b50b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a1edd8f2a70acc00e04f443afed3c982c41b6f89ce12ee70950fd062f0ce1fc"
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