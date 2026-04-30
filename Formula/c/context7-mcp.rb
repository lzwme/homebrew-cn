class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.2.2.tgz"
  sha256 "22283b6a8086f4607f0d1a10aead97725607ea392fe868459b54db1ab82330f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c792e605fb517b987b229cb8e93ca8dfce8aec23fc7fc356a82a2ee3766ee814"
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