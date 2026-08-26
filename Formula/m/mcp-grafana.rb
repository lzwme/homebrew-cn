class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "aa1dc99744d14ed4f491c6daa22801671a635b5dd7be441a71e19e7222ebb272"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac83ea28317b884f99ac56f48fad2d09d225febc1615a08bead40179d97b951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c88252a03856b8fcd00a3a0fe6b4141b4bc706c764873f1ff6fb75ffcc9e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c191b98ba3525eba589f9e69d736152b655dd3e42bdf481f826897f2a5fa35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "944e1cc7821bc7eaa08593afd467e8b50e63fde62da452281e882bccb7fe72dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e8233220899e10c467376f86c2dd2e6a64b4b61b253764a9fc13c35d010b570"
    sha256 cellar: :any,                 x86_64_linux:  "0df1c73fda86880df55352ced7ff3114d7d7c12e71224ff8b355addee5f5564d"
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