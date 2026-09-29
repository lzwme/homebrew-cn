class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "ff59d7682d50359832b7e40bd97030de5ae8571fe2ecaac0fd217f33bd54efa9"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d50af62bba1aeea2a6d6218644a717b9412aaafa4be1b1fd2ba976b20ab480a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ae0dfcdac1bb13953527a9d24e019886083cb11fb791c24c9503d36dda96fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6e550ea6f4fcaafce5c02b1c759e2a394ac01ef46ec687fbc9deedd7f6203bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a3613be0f95413877cd5f64027a57cd4a30babfe6b011a9c02be37636d3e010"
    sha256 cellar: :any,                 x86_64_linux:      "327dd53c31bd2a9a46784ed86958ddca04bf0949edc5258d3257cd28c0ac03ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mcp-grafana"
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