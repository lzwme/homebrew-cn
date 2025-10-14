class McpServerChart < Formula
  desc "MCP with 25+ @antvis charts for visualization, generation, and analysis"
  homepage "https://github.com/antvis/mcp-server-chart"
  url "https://registry.npmjs.org/@antv/mcp-server-chart/-/mcp-server-chart-0.9.1.tgz"
  sha256 "3c0411a18b61ba14a9f9686913520b3c0746be048eeb123390eaee51db422949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "838b713d4f2b0df0f8d29bdd7b91e59a9feeeb9320d4859c4f5594e0576347d1"
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