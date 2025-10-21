class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ba8e5897500ded6aaf974416bfc2bb3d6800e75cdc34e54d062a23473216cee1"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e97fef7d0603d71a9ed3ab489b26f04737397a7c8ef9bd6e8fb18d6eaa7771c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e97fef7d0603d71a9ed3ab489b26f04737397a7c8ef9bd6e8fb18d6eaa7771c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97fef7d0603d71a9ed3ab489b26f04737397a7c8ef9bd6e8fb18d6eaa7771c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1589fa908709d17db632a726f02aa886a994964493a0a310ed97e3eba422e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ba0fc5c6a1ff06729571016881698de66ee84e67dd7c3094871f950024bfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86b3b703c9df85b2e16c00437238047ce23202442e5f0798bd576f8c858aff26"
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