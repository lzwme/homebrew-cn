class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.11.0.tar.gz"
  sha256 "7712e780369e9bc19bce97b558f06ff056bcdabc4d927f9f600c8cf8f28f50d5"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14b6b756dbe3baa70312b37498bc11c4930fce3d08dbec7a9a940bb0f92aefe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14b6b756dbe3baa70312b37498bc11c4930fce3d08dbec7a9a940bb0f92aefe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14b6b756dbe3baa70312b37498bc11c4930fce3d08dbec7a9a940bb0f92aefe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4aa473d0c85fd94e370f3db32a3adf238d7d9550d575e0a2f4e9faa41df09d95"
    sha256 cellar: :any,                 x86_64_linux:      "6064978a52f9aaab43543154aab0163f76d8d728bfbbcec60b1e927f59126eae"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # Read the reply before closing stdin: 1.7.0 exits non-zero on EOF without flushing
    output = IO.popen("#{bin}/gitea-mcp-server stdio", "r+") do |io|
      io.write json
      io.readline
    end
    assert_match "Gitea MCP Server", output
  end
end