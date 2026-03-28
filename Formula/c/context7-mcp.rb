class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.1.6.tgz"
  sha256 "6a566442155ffe689f63059a7d93dc3b19d72ea6e08b2611c3e26f5aeefaecc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14094eb1c86f92e75011bb3db7f80122a92b63aa8102ab9c35ad1cfe255daba9"
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