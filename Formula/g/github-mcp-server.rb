class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "8f6c5902a6ff1f46c1eba6d9d7b405ecf436de42ae1847f7825c56db85c1098b"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a429cf061a6ee77585696937e78c72b8b7a011b908cc82e5854483a8b0fe338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a429cf061a6ee77585696937e78c72b8b7a011b908cc82e5854483a8b0fe338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a429cf061a6ee77585696937e78c72b8b7a011b908cc82e5854483a8b0fe338"
    sha256 cellar: :any_skip_relocation, sonoma:        "b182b1dba95b77c56465df0f0961e2b8259c14f774ab645002cbe8fd2199a467"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "328924c314d73821fa02218eae21a8a264f9a05dea28ba4807c9452994b4bc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d569b2957ed00031405c0b8270ceb8fa3ee20bc2778bf2884bdacfac5ce4c69"
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