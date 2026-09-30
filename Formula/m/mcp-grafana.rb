class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b2382e5ece8f75187237d770488b25986af5a31347dab7d82004995f4459bcb9"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86028bb9fe0ca25821cd43ea58fbd91c25e385c5760e2d8b8b35cc53bad35bf9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da160534d6922a7d98e23431ec955f9b186dcf903447c22abeb124e91b971857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db0314d0e515abfe4cfd4a6414e0e070e65c5871fa306e140d88b0dcee74c1ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c57c6f1953c2fb36e3b0aa04b236b358c55f3c0047a5c4f565020ca31f63e8f7"
    sha256 cellar: :any,                 x86_64_linux:      "ef8ee22cc9a0e39b4d7af4db4e93d5820af9017c22c34a3999c0286cacf45198"
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