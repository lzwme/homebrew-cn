class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-1.0.1.tgz"
  sha256 "9cb7f91d41779bc784126b7aae5a8e2d7ac5a391b863d945d8b613e2e98cdaf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e605f0137b630ab7da4fb2017a72dbbd89fa40d3e4796f9318e7862fbd463ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b7543045eb6caca1e1c68781d601b5d000d405536380a81d01dd68f9edeafc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd04831b2d28c4ac7e7d4e7f13b4c4ed27b2592644d5c862e599b411178b4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613a7aba38d3b9a1c4e5c68535c6f25ecc9ff6b9078f964a1995d8cb79ddb5d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    # Remove incompatible and unneeded prebuilt binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    rm_r(node_modules.glob("@rollup/rollup-*"))
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end