class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.8.1.tar.gz"
  sha256 "5ff3527a40e50011b0426e908d86ef2c424319c423d3b69b779f57a66c898520"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eebf8177054d4e82dc541c48f262df119609611e0f38f04908cd274200db4c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eebf8177054d4e82dc541c48f262df119609611e0f38f04908cd274200db4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eebf8177054d4e82dc541c48f262df119609611e0f38f04908cd274200db4c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0290e99d57cc8e6479124d9be4671b9877f0e1f94ac38905caf41a47c639e591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed52db8eefeb548ef9fbf915711bb8831a8afe5c41674357b89ab041d227ae1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167ed6f58ed783b7e5a1fa7c2b8976730d00bc33eaabbf63195b12b561e7fdae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output("#{bin}/gitea-mcp-server stdio", json, 0)
  end
end