class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.2.0.tgz"
  sha256 "e8993e3d41619858e1c0eafdf03765a6188c889aa0e80f914fbacd10416c621f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2ff05d309b1a38c2b66a09d56f45f9a8bb2b40e53afb3cdde95627b8ac24c65"
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