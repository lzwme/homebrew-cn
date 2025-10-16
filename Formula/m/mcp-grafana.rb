class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "b27cd495b55a0ab3c7fea613ed61c2ae2c497f08ee57d90b5fc36844bd0ef617"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93b439b49bd88edf38278146d735dcce7a5dfb60113607946bac55cfbf66a506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64fa679e04d14f29b7bb418780212dcd8a39d71dcf1c89a272d342cd45a4497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8fa615334cd1475438949b6ed66f7ffa3cabb1674219f010b4042ad8f8ebdbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8675196f1a5ac99f2c156f4b5c230b64237e017ef82805f0c31a1b17ff69ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead120836ddcc24b8a99ca2f549664f75acf1f12d54ddfeca8fe835f29f1c242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d8cb06fb2a7c1ef77069d6c2cb0409f9b55b8905bac399a0973ddc31508b1e1"
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