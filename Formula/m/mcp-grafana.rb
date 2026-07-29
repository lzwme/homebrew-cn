class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1b36ddb1e85f451bcd70560e82623a437810c108a3034f53c7747a9ad8be6c65"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ca5616fdd1df10331119fc1a021f4b6cf0c216689cfb7c2de5fb71a717e3e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11fbc882a262565d786a83e03cf8c5eafb5cef5f6df7c01eb80146a8c086546a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9dd0de7664b0f8459a6f79b280bbfa71e3bc7b4de54cd07d326aac01f5db90d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6489f57ee185533cac5041e9cef0f285b2befefa97af61626bc5ca618219641a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77939b72571aa7cc6b5bff9d6d9d67692a7ab05226e896940c006969e0b47327"
    sha256 cellar: :any,                 x86_64_linux:  "73c4187feebf749f148a9550c9c663e2c45a941a43a56d9c5db3c68a90e8d193"
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