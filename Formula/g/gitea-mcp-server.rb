class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.8.1.tar.gz"
  sha256 "6540170e363376fb241f59a4e2d3836f99fa1682ff9ae084fc45ad52ece77756"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6e551c353c671487b6da4211ff750ded7f187c30f052e453dfc355d43f28dde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6e551c353c671487b6da4211ff750ded7f187c30f052e453dfc355d43f28dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6e551c353c671487b6da4211ff750ded7f187c30f052e453dfc355d43f28dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "262a6555edaa40d706b2b8d102ed210addfed51f2ad1e1fe611a6f5cc5ced9d7"
    sha256 cellar: :any,                 x86_64_linux:      "3c35138bc2569df9c6da56f336cf9da19dd130e8d3070d8f2d18d4979ae482a5"
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