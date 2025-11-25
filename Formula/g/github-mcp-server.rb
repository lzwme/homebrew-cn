class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "ca5b0757bb2798d55e018b1682520022653da5254aa4f1821ccc82fe702c65a5"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bae695e8ede61a41c711950db0a9cd766c28ee82e7f85f285d676335c4401d28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae695e8ede61a41c711950db0a9cd766c28ee82e7f85f285d676335c4401d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae695e8ede61a41c711950db0a9cd766c28ee82e7f85f285d676335c4401d28"
    sha256 cellar: :any_skip_relocation, sonoma:        "983a4f10d8d69844aa4d011d4f314b010f16f20586f37e47b7f494c2bc810ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f952dc42e14bd443a978be56500f46424b3c4b552ba5d82c1fdd48640616f1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae2e979e83afb06b44da95b9eb94f91b0e6558a0c24bd6d89576fbab5959c37"
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