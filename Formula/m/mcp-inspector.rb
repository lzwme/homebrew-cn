class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.17.5.tgz"
  sha256 "a65bbad37839902812f071b853292c7f8775f826f6fa4a515486ca269a98f621"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5743d861c3d74911624e967b885e5d93265aae24107a04dde1461f984e27f64"
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