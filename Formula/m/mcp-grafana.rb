class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6e9c9f85f22cd4e3ce748e95b92a3aa7b208a0746779cedca1698e766042495f"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "010b0512c6595c21c0cd2e20ea6109de67f36f03b9d76f698085083b6076b649"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "655a565c1e82a9b007d47aa38707f6eb2f8b0a1561be536e6ee633a1d209e61c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51f4888a18049aecd30f02bc14dbaf3b07a4b5796930c22ea222e8d40dfe74a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ebd19cc31e2a400fc2ff54c1dd21a70e4b15707de307c7733c2440f6ed94a6ed"
    sha256 cellar: :any,                 x86_64_linux:      "e50b3f4bd243f35d617f06c3d942d0e29bdcc46a92e66e9cac031d68bbbf61e4"
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