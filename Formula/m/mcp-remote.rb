class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.3.tgz"
  sha256 "c9162084cf9d6e2c9e9c31da483d57dce90a45fa7dc95042a02718f7ad94917c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f009086a37c568a8ff2d96bb218dc07138fa3f116841cb3442b3a8cf8d08345"
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