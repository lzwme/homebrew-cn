class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.8.0.tar.gz"
  sha256 "5e5f6bf5a08f54bbd7ade8843a17cf96d6cb746fcbca3711f05db7c0d200129f"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e83e226999ff9907f25b7451ffca7496478fe42484f8f2429ff996e7faf642a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e83e226999ff9907f25b7451ffca7496478fe42484f8f2429ff996e7faf642a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e83e226999ff9907f25b7451ffca7496478fe42484f8f2429ff996e7faf642a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b2389375981ae79198b0e60020c9f12fbadce714cb60685787783a183692d65"
    sha256 cellar: :any,                 x86_64_linux:      "e2acd3d2b34561450e6d59878ffaf346b241ca2676817e85f9dcc244963d51f2"
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