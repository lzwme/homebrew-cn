class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.6.0.tgz"
  sha256 "9b2d3238a2b3aae71a57058f00fc26c75a736e4bfcf348616fc0356bc5177d9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c048a68c0a35b82e72f72a9052392f6996244e74919a7de6daee3a6ac8ec5b1"
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