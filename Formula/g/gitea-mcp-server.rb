class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.3.1.tar.gz"
  sha256 "1cae07522a6424005e71f853f0f5dd7f43d74d0d4ff760890184c5656b6e2e61"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e65cb00470c34a074c02194c9a3790d14a75af2529abab50e2a0c145c937e088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65cb00470c34a074c02194c9a3790d14a75af2529abab50e2a0c145c937e088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e65cb00470c34a074c02194c9a3790d14a75af2529abab50e2a0c145c937e088"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf801f9b9a0b925ba233fd63521120616b5349b56f01fdb4a0ef92a1437ec1ca"
    sha256 cellar: :any_skip_relocation, ventura:       "bf801f9b9a0b925ba233fd63521120616b5349b56f01fdb4a0ef92a1437ec1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c23f56d32908b8c50282e69acc2b88bac22c797d731f1c2c9cf22849f126733"
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