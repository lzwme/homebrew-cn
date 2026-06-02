class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "41f36bdf4dfa6a0e927e930e867fbce34f0b9e23d288696eb2b3edc735a45d6e"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0edc25260842807d6cea70ceddcbb2af3330f9198add3369606c62ce136c54fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495e3027cd64153615aebb6230501473dfd29878bf1b1edd07948b43a63d1049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5903d84c77567b28cfcbbd5e1cc2be4e4dce701a94d5b13a78a81ec60d33106"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d652a198c2f9ea101da41929c3991b59be98b4f2b8f3cd56b4bdc7dff2965d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff57b3e359c7d9581308f9d4cd737d3956f2b58b929d952477b39d7781ac94bf"
    sha256 cellar: :any,                 x86_64_linux:  "ce964238b489757e443e5051679c2bf844298bf40378dbb724475378666c0263"
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