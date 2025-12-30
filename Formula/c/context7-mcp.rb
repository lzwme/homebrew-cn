class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.0.0.tgz"
  sha256 "260b2fcfee88fb5bd57f69a65ddb039aacd0e7e3b856a579edac0553ea7f0aec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58e33981556904c4a3574ec120cad0803478eeb5d69b6de327e0807a11fa9c04"
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