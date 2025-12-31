class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.0.1.tgz"
  sha256 "647b805e68bdcb7dc86e0d264662d616b20a0181b33c174d0afbca25745efa65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9904b40201ef6ef4f5296b885fc56e853aab0a18854b4148a74912fdae3cfd94"
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