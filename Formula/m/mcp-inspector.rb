class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.2.tgz"
  sha256 "c52f7b64bf50834416a26e01dac8ab770ef6c7e45b840370105eabc515447e6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40d8c996a7bcc6f3b3c20dc5c8baacc89b63652d6276bd1bf2ccc0c72f48f9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40d8c996a7bcc6f3b3c20dc5c8baacc89b63652d6276bd1bf2ccc0c72f48f9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40d8c996a7bcc6f3b3c20dc5c8baacc89b63652d6276bd1bf2ccc0c72f48f9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "da67fccb516aef843ab26aedf04eeb91efb3837e87b31a7ae121b6fa807f03f7"
    sha256 cellar: :any_skip_relocation, ventura:       "da67fccb516aef843ab26aedf04eeb91efb3837e87b31a7ae121b6fa807f03f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40d8c996a7bcc6f3b3c20dc5c8baacc89b63652d6276bd1bf2ccc0c72f48f9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d8c996a7bcc6f3b3c20dc5c8baacc89b63652d6276bd1bf2ccc0c72f48f9a3"
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