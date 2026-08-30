class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.8.2.tgz"
  sha256 "3ebcee6ebd7fba095730123467be49d77726801e81e26dae1395901a7ed828d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3f6f2aca69b35b7464038d673ee220371a1e3fcca6e62b3ea96307b211f1343"
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