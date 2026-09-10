class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.5.tgz"
  sha256 "578f3a20ef3aa75d09b94cf582208d9dbf5e1c355aee41f0ea021bde627ec255"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf0ede2c7e801eda4fb62054f6df5fc325ebcd29ad4d6125dfbe7ae5502f89f7"
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