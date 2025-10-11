class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "cae77d9958adb2f1db95d2d9711d1559760bbd2124aceaf749981e39fd318a47"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a2eff806117f51343463c228d33d494305a0257a6a5101c25b9b509292acc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d712aec18ff295671278249f0aa1150d45680fccbc9d92fd535c8e915deb2efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23be6e8f42c8d82ab64a06bd45af2072f9a0121b75a039e48a7379b6c7543d22"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af1fc1306a1fe470401d566c80db7a8ff13e9cd6d95da255697984c54e66301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd406e4127808597e3c7bf894f9dcb1671972a761ae266b37ab59fdee529121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9ce5dff47fe1147429515650ce853f05bb52a5d3c2413446dc9406da11b15f"
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