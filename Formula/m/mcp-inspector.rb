class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.16.0.tgz"
  sha256 "648bbc925cb55b0a803f15c955761bd327b33f5d990551f7b6d3c75bfd81f603"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28845347033cafd16e4ef16430ca3208078589a0d4a6fc9013f0d262afb1f4bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28845347033cafd16e4ef16430ca3208078589a0d4a6fc9013f0d262afb1f4bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28845347033cafd16e4ef16430ca3208078589a0d4a6fc9013f0d262afb1f4bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bfcad01ddec4b69e6df5e2c7b43d42a1af769252bcde216fbab9fb363e1536a"
    sha256 cellar: :any_skip_relocation, ventura:       "3bfcad01ddec4b69e6df5e2c7b43d42a1af769252bcde216fbab9fb363e1536a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28845347033cafd16e4ef16430ca3208078589a0d4a6fc9013f0d262afb1f4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28845347033cafd16e4ef16430ca3208078589a0d4a6fc9013f0d262afb1f4bc"
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