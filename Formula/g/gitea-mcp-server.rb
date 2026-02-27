class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.9.0.tar.gz"
  sha256 "204ba5b7b437a2f52defa3bf8a0a2aedc5b3d78a1e92a486ae580eba517c95eb"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436f40eca2b672a5132d8b6ab350e20fe7a42b03dbbe4457b29af1452f821ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "436f40eca2b672a5132d8b6ab350e20fe7a42b03dbbe4457b29af1452f821ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "436f40eca2b672a5132d8b6ab350e20fe7a42b03dbbe4457b29af1452f821ca9"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ee038db75e1f14036b19b181862e6bd63ca4ea3b2abaedf145f531b3915e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e64a897d68b7cca5cb44c5536ef847a43227063802a04e8dd6c3b053ae2a0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8be682e0396c323d8e1d24a2769c0bdba0c0073d4a64f8b0cf41f8687de0acd"
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