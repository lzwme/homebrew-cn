class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ec7aaa100c31538c8c490c41f8a078361d42d07d056b39a1438afae7ddba527c"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c17c48396f7aebd4d373da7085933facf8105ddd1a4a944f321a7c4dbb2bfaa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034717cabf71ab5d5be112b1eb6f0125a2267c160cf892122dc3f9594fc290e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0379c39f61f36b7520d0aabcf887e28ecadd61b1542d0922497ad6f9e9657899"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a5758ed8bbd69c385e6031bef07f323df99333935fd14ee2a8f49aa12be8ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f23a4b94499f3b4e3d2eb46b5010c3650bd92ae7ad76a2a6eb5a6604cfaf131"
    sha256 cellar: :any,                 x86_64_linux:  "5036b5b9ca2f56e88a59de19580e2d84c7bc8052af1073b62e94c2cb33f21b0f"
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