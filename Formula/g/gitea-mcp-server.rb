class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.2.0.tar.gz"
  sha256 "f45ff51d093eb766bf90f8d2f48dd250ee3573fddbc05dfe33d9d19a6e8f86e2"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2010f18edb269f3981a03a7f99f68cff843de8da38b46bb293d1f1662171705d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2010f18edb269f3981a03a7f99f68cff843de8da38b46bb293d1f1662171705d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2010f18edb269f3981a03a7f99f68cff843de8da38b46bb293d1f1662171705d"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ad9430627ec7dfe62970fc633e5cef5379c8cb9d10a09b4d30aedb1f173891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a06e98614e3f28516d9fe5af144c8f1f048d81369ceb5461b0967e38e29edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74132e7a6cf05f5417b9d766154985e4de3c3bf69cb0f9574b8ee61a04cb2313"
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