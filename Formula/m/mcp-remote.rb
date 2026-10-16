class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.0.tgz"
  sha256 "17b1af212c06c964f92220ecb45f6fd73abd3f818471d2a518f96870f43ff2f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91fa17a184c05d865f3fab4cf8c577220ca08d1abf08bf9ba9f346d098682edf"
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