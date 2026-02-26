class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.21.0.tgz"
  sha256 "9ec70da926d7ad177191171e1b1a7a53608f70f477c7b5f98069331010bc8afb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d50de239eab8d28569fc6daff103015df1a61d48caa0148c6727a2710c87cb2d"
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