class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "17d8b5aba2619193babd2a32e1f4cc37e14cb467b2b2381b655868714ffb703b"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6d02d19db1f7514866482ff14f131efaa1ee2ff9626cd0894380e335cea5cfa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91275f20210024f103339033c1a822ecb3613a8c498d0b4242412909d4f62e70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d435a5c8b5a7b4ddfeed28945431204534d342854041faff4589e3d86e44a74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27cb6b7cdf84dcf11a1a23f9488ed3c1f2c2e8233193c102f97abbe2e066536a"
    sha256 cellar: :any,                 x86_64_linux:      "6279fddd6bbfd97719efb2dd51a270023e60179bb2164ca3122ae603e7d5eb26"
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
    IO.popen([bin/"mcp-grafana", "--usage-stats=disabled"], "r+") do |pipe|
      Timeout.timeout(30) do
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 1, method: "initialize", params: {
          protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "homebrew", version: "1.0" }
        })
        response = JSON.parse(pipe.readline)
        assert_equal 1, response.fetch("id")
        assert_match "This server provides access to your Grafana instance and the surrounding ecosystem",
                     response.fetch("result").fetch("instructions")

        pipe.puts JSON.generate(jsonrpc: "2.0", method: "notifications/initialized")
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 2, method: "tools/list")
        response = JSON.parse(pipe.readline)
        assert_equal 2, response.fetch("id")
        tools = response.fetch("result").fetch("tools").map { |tool| tool.fetch("name") }
        assert_includes tools, "list_datasources"
        assert_includes tools, "query_prometheus"
      end
    end
  end
end