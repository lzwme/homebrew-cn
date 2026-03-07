class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.0.0.tar.gz"
  sha256 "891c99ef850c3b5458579e4a8feaf5ef234d6647e7788454e18ac7e105bfa717"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673eb10e3e57d905ce18e2ab839517b37e642793722e9705ee4d5997309b41bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "673eb10e3e57d905ce18e2ab839517b37e642793722e9705ee4d5997309b41bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673eb10e3e57d905ce18e2ab839517b37e642793722e9705ee4d5997309b41bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "566ed7db46d93310d1705aa8f45db7b2b0fd0c74a384c815b3c27ad125baaaf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4368d7400f037b4abba154fd20da942ee2d45177fe8c55758d0d3e1aa23641da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f1061e38469af2874d999b461b89b7e3e799009ae27b18687793a4f07f4978d"
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