class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.3.0.tgz"
  sha256 "7bbc115a220db293caecfb49d69863c5dbb7669217b929b17bcc50f556d84073"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10bc2a98c03893f2a0f4312b59f9a2fc5460f336c11c30252ebc832b83ad1acb"
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