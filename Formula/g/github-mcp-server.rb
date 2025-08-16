class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "2907cdabdb97720801fb0f81292674fb5951ea189acafe1689af9b74a331f78d"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7294a831e6e04202cd6609f1c1224fe6f586f4bcec230b0cbfb542aeb06952d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7294a831e6e04202cd6609f1c1224fe6f586f4bcec230b0cbfb542aeb06952d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7294a831e6e04202cd6609f1c1224fe6f586f4bcec230b0cbfb542aeb06952d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56eabf439f345551fdcc4be805c90158e5f1847f0d3505d2e4f0c9078a7a5ac"
    sha256 cellar: :any_skip_relocation, ventura:       "d56eabf439f345551fdcc4be805c90158e5f1847f0d3505d2e4f0c9078a7a5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98715d215c42dc5b76775bab130f471e9369bd994b7556a9ad50d36a4a07d13d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "tools/call"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 0)
  end
end