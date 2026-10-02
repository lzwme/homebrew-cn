class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "89a24ba3d67b784a22bbb2a5e529dc7e0afdff50c5c6005dd04df5c00b050baa"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49c486dd66b383fe0f8cc15f3a26baa3251513224baa49e87bee32b9fe34ca5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c4b6289ef64e18440710c402c1bfade96eddaede2e57ec84df587428c9abd44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c28df4fa6969d77b221025f9d73386d870e30e7a5113fa33198d858a3610fc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee6c020359cb4ca2b6339b802fce4529de2e0a337f478f1250b973150f3bb072"
    sha256 cellar: :any,                 x86_64_linux:      "adc9986bd844ae578edb2ef112fcb4c01bc20e5ce8ed6cabdef8080228cfcf35"
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