class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "0687d4aa2579b844a44306abc85271dd1331b5d509cb3a4dac76f74f7d597947"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dfaa2c183791380978c2dd5056b2574be581928e9a14db0f18251474c54823e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa4f031dc57f52908cb9d36eb15825ed92edfc3929399e0636d99198f11dea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d5acbdce5498288f99510edf1cf26e58dfd6604d74ab75dff7b27f37f3e43b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e900fa8fc092558e43d43ad34ccc8ca227dd9e9c3a2c9f4bea372fa26bc03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10e732595156be7ff7984c0adb687d2c367abb7e7a12841981730366ca74fc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8bbb32749233d0e8d4d7fb852d46a7a64b3bd026fd6b1b2cb512372dd23ea4"
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