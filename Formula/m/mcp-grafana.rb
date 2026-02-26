class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "7a6a48feed1185dbb79e8fa03229c37dccb018f1fd26818a8dc4826cfef33a9d"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f5749f52fc90ff9ff8f81269423a7225d9a7ac57968cb69919d063ad2a036a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03dd8c6a79be2995446601576f4f2c9c1f77eb52435e51c81209dff18b5aea4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9927aaeea983f4367306374c3c0a361276b8f012c1883282d1ebb3213cf13596"
    sha256 cellar: :any_skip_relocation, sonoma:        "994a29115af065d6390dad54b482f7ca5408d2f387186bcb802d5085e02bf9ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c8a8c147169191ec72504eb32123bfd68651d301d549066a8dd2b9aa9636c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5ccf42e7ca96d45f7d85d268bb037cbcb347fa993cc63c509960abb99768fc"
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