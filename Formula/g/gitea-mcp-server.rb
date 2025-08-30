class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.3.2.tar.gz"
  sha256 "7a5eef86d1217bf607656814a70e96f9093794f17ca223dc957dcf7b503da855"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d124adc4eb69844159365083581823b2ebac5853b043cf57e77f46df27b5e0d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d124adc4eb69844159365083581823b2ebac5853b043cf57e77f46df27b5e0d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d124adc4eb69844159365083581823b2ebac5853b043cf57e77f46df27b5e0d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e5b997ee1f9ec5b0bae198e3a7588bf18451ca26b86488e2c8b1d62325d9b9"
    sha256 cellar: :any_skip_relocation, ventura:       "39e5b997ee1f9ec5b0bae198e3a7588bf18451ca26b86488e2c8b1d62325d9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6610811806ce4120d81ee9c1caeb53f9565a9a05c3e2669b51a74ca4bf54150b"
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