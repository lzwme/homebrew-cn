class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0e5c3849487ffe6e8c8804ef600aaf1bcbcbb182fa202636cfe6d8deb9f5d3b1"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "279ff618d2aa87cb45eb13cdc4e72238bc1e6f2bb08479b99d93593e56d40a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8178204f872aeab661cbea2ba7b5ad383a66858609a0c82b12ab40cd4a300a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e14039d4fcd4c6bdf5f71779f81aae816fe843469e3e3b4fb4956695847e778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e15283841122b32347a0516c805e5ad91a6bb09e98d1d41e70d285531110327"
    sha256 cellar: :any,                 x86_64_linux:  "eda0a9d2526c346285a49debdffa8cace61684ff99febc0b209054672da228bf"
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