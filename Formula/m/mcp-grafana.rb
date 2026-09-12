class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "1cc5dec0d45a7bd111f3a4f56795a3645a9cafbaf8c5ceeabc3e7f97022803f0"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0625cebb22ca369abf8e6b6627ad6f47e421aa986a823ac16a6f25fa1629fd30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "651be42bda1a5e8ef708ba5db65774c0defd176e46ec79c0e069919329eb7f71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aceae60166004df01f404a29f52a2d124033300c2a0093910aa317d6f1189385"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08a1a394e0e5f45b4ddac8239f0de813b60b62520db021c1d50d0cde15db1fb4"
    sha256 cellar: :any,                 x86_64_linux:      "2745272d594103b7b3c9d441cb1e7c6e67cade6f5823208fbcaa795d6a97324a"
  end

  depends_on "go" => :build

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