class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "b5712129b63444bca11aad2d9c002bb07fd2e60c098707035d8ff5ebd3fe3431"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5f76cd7fec6b4f880cb79ba0720cce1a52cd07f695c12347f48aac7e1142ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f005dfc8a4abc4b37b743f47b4ac42b4394410484242a5567f07ec79f6cecd91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bfd5ff6692a70d614301a18351599365d09a4532d367238b9afd5773c51ab7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "682701b4201f6d2ba05ef6bbb32639a82096fbb1b2bae9a2b053b321d9eeacaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efca9ad27ad7df389431374a4637c68700b6e87974e509e09ed04c1fa80fc25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a64346fdc5f52d3e08eb9e28a0dfb46dc9bd82983eec2b0c042bc3df7397e46"
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