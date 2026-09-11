class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.6.tgz"
  sha256 "57a6f71b77d6877ba3530f00db4c800b1de6b2e416bf1555b4cfe2b06e6cdd7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1aca33f3d4ce9fdb8245c4d5c042ecf41dfcef5863595aec91d913219bad0f95"
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