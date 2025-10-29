class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.2.tgz"
  sha256 "c89629f7f4576bf1f7e564d42beab481c10838edfee644e1a01be1e2e9c8b81f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bac52d677833e3bf444f81438d2f270e48fe90c8b39800b776d2138dfa30a64"
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