class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b529eaca9b45808c58ee846279f78155384efb1d9d82d124576e087305b38321"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "182e1c7e393dbf95e8da710afded6b21e67537d616b7a01f0ebdaebff0354900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e355e07e9d923997d2a191908dd0a0f82780b4a39b7df4b827d9f4b57f77630d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faec43f059fb34c267ac3d4b083668e410eb82ded2277df1257fc8390066a4a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc64d82c36e73cc809a86b0066f16181c2ad975abfa75c701533954f0e077ca9"
    sha256 cellar: :any,                 x86_64_linux:  "b7e5837ee491396b0e1be6429254ddbb66494ee6e380d1a3f170854cc9f6add5"
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