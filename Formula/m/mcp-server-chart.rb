class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.3.tgz"
  sha256 "4175992432512ddf28a6e6f76cd9cbee05ee77b951ebbffc03d519c0da5b776d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0684300cb058daba0c43b432cdbde5e9316331fa3bde27197f5ad65faae8daa2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mcp-server-chart 2>&1", json, 0)
    assert_match "Background color of the chart, such as, '#fff'", output
  end
end