class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "b8e1e33db5646b1f1da80ad54b5c95fc07733814b61fb5383fb66d1232a838a5"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "840ad1dd47b0708bc0855cf57644e56a68b39c98d3bad1beb3ead6e43e561d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04cac859c295d58f14479d2e5938dc716bd55692ebc5cb57bfd7680f39c8a603"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca0639e525794cc4a0855f1c4f990dbfa787edfa7fdc8eb23dcd5eaf13d75c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3405cc45e849ecdd449ce5e6228e26e6eace9f593d0c7e348d33cdadceb667e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9335a6b827db7b0f6dd5a793899eb537ea67558e81c71c52dd581e4f7c91cc"
    sha256 cellar: :any,                 x86_64_linux:  "9b9614bbdf8f24fc2c2037a985ab4002985d51366a80c25acea5f27ba4d052f7"
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