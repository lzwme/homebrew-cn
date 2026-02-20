class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a2cbad42f545cee362e701180802d28908f0b722ccd60c1534125c26c4491b75"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5964fc20172cbbec5431e0de1a2089f226ee88575be6d5b5db5bbe600aa15264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6096f0f05252b052de77561b8614b6a816fbaabc6bbba6d77d6b7d4e154e0db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1354b2e6f5454734b5acf7d468b11a8757a0fbcd63b71ccfcc929d9803c16539"
    sha256 cellar: :any_skip_relocation, sonoma:        "59fd3030c71f00e2ffdce2e3f0054efd384b121c18cbff7ef099f3c074beefe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c5b282250a8254393a714c314c26e653b4339d73c9828aa4388c1711b966583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f02a952be7234fc6aa0901b4b401d3f71d6073b1104d12342236e738f7cfc4b"
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