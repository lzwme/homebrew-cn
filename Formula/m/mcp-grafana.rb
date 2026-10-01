class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "9cb347773eeeef799f79d89d26b75b09b3d0f0f62644b0ec75b91510cf47d110"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ffbc95e220cd3724dd01b5e37c7dde9ebeda7bfdc9a8d8a9c243e2c5626d787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95f259bddd672c371d544d4bfb90ff6ee448c058d08ddd31071aa2185def8590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ba649d7c025373169306e50bb214202203cc5dd2146e2cc8d8d1240654463d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ceef45328cdd0f9eb1be2d25c9fed15fe81709a11849de697aff014aa3046b6"
    sha256 cellar: :any,                 x86_64_linux:      "fc86b0a99e26e3e50be501bcf9ac76d986f3b0d7dd124d06980a2021f6925258"
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