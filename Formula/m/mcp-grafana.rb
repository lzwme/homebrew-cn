class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "d93953344401f7e29efab721470156fadb1189a2a2b2b1e109c4ac82a6fd59be"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d52760b6ea0b0848078ad6f72c206a51f556c9b6ae0494b68d597330cba0a21d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e00516cf4d388136d6350bbdb10d8398cfb7a64dd690e4d4f43281a975b3075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2eb814edf3b0855a703527ebdde622269254bb83a0ae60a8c956fc3342a606a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c38f2d059cb314be9bf74672edcba430839b9040f3877390cca2852f10a7f87c"
    sha256 cellar: :any,                 x86_64_linux:      "d527266495b48e75eb64d803cb83b85ca063620fbebfac0beb090f1b2ee5f2a5"
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