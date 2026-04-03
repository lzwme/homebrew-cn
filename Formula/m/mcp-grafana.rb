class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "25b53302322c606a57b4e4e31e47fb2e09cda241e26aed3f980de44d8e754dc4"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41da8b82119eda3e75e66dc244cf955d376658a60c038cdd8098e84b0c06e349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f03740df02642f0dd8dedd7ed92dae9da44dbb6365cb3acd9e2bcb26a58467d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61e44c15a29fdb5ba18ad8b8c223e1d4465d4d9990991d058cb39333fd4818b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e030d3dc21f85dfa0f773ff841fea3cb0e0f931e95e28d1e99aa06d7d630812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78046ad4bb7352096429a0a8451ab8084e563ba4ce5c1dfb89d85d69e776a9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e10a464015f1388220245d827e477303b3a6324d5952465c541542f1026a776a"
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