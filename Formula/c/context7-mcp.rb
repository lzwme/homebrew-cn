class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.5.tgz"
  sha256 "c6ed2aaac7f67cfb94eb35e72a48c4c1204a815f54e15ae6e96ed3465b9d58b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5227eda84a9d085822ae11e5926b7df8c75f997ccb96fcd52e39ddcfa3b9af09"
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