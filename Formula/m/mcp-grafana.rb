class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "47032cb51eb29582984abdffa0e595fe1d2d37ba13ce63b657e4885707d0908a"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f696637014d51d20d69ff8fac9e214f68ca2b19b65981271163c819a863fe0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c746cc6cfef032bf8a36f9d28b99737fe9030c542fb1b62bed796779b2ba44b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d996d76ecd526ac78543e315ba4c9bf713eb7e88f54b7a55f674a5f7951f24f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c884084669379b0a9ee62dfe598d2de5a866f1fa72d26fded3197609e5a07d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2459ee86004206fa5620212d835a89b404176bbe177509dd2a8f02cffe2c59c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d562830f41afceadefa02c211296bce3282c4419138db4d6fed8d41acb0c90"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end