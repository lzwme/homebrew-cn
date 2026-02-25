class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "3025c96777621dab08f280a989c168798c506e36928543abac038d55cd7ef2bb"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee28d18937aa27397c13fa8a5ff81a665eafde90fcc6e66b6b346be1df445b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b218ec1fee394a092155db911de8ba5b594cf7f59c6faee4b4b921d1022b8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b677dc21bea4d3ba1b5cd4bf9b433bec322e80b867e6e8919f80a6ba180e22f"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a42d67fad28861265da290b090de5d34d12e92e4b9d08526ee6329fb42f9ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a09b85e918105a9ae6c69cdf004c418b685eba7332b534c2c87adbd4e152c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c654684af97522f2843f22cb8366d8c2158dcd06c24b79a6f0ee3ab97aab78c"
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