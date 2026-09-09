class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.4.tgz"
  sha256 "89414b816d934f61cc254b0715fbec158522dc076bead243f3a4c866d458bc7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "072617c43d1fe2cc017ffa0351c82c077765e0c9b90e7faaacd84e2392f1b44d"
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