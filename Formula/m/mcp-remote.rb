class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.14.3.tgz"
  sha256 "f4ab0e33b38b24fff6a8b3234f9d683e47995ca44f3186481716d444836f7254"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fa33969d67a6a6b1a97d19987d65f5d70701af31d70a08b927fb9bb1cbdc19e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end