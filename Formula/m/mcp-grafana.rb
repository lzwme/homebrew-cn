class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c8e141bb3dadab63bdbd227eaf7d257792a3d06cddfe0ae31a198d17e334a843"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb67d9ac67070ca00aaa96e233a754b01fef0cbed18a495b721509770d01951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c91301f8b3826d7ca25a9c2b5b2f3d7c2f270d4654dc26514d7890386b369a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2befaf234a1659052c0c9d6dce988e5098f1e738592ad7f0475cf9fbdfedf1d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2fdcb9335a5cf346da2f022cb3c739fe201ec363251d401fe7d2d55f9dbe70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d022391ced1f1f503d3508fb8b1e89214ebe8d127843f5d667361dcaf8c4993a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3fe7a6f9e2a5554d885410238d795e38c0ab11777d58cdb2eb9de60de12dcb"
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