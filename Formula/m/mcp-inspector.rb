class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.5.tgz"
  sha256 "7b82b23b163c2ccaac90657989d88b4dcf506c1ce0e49aa0799a6612ba198d8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c94a79d042e8985c864c20eb6bb7adb825f3722def806cf00fe00129603af2f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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