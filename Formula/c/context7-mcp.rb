class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.1.0.tgz"
  sha256 "968e0ec663c1aa3b2ad542128324077bee3c28a81b5c579b6207ec112ab8d8e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46212e43e99a64df7a73e5afa50079d3a73677ec524d978843f8a282ebf692e8"
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