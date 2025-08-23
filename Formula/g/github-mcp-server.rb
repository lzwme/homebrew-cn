class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cbf61aa00e00acc9162fe31ae3254de7a96dbe2795a027c53b12b8c1b39b9c33"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25a67c4cc93c138ecfa98a6b5b002d9140a6e41ecca6bd714c624840b8ed862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c25a67c4cc93c138ecfa98a6b5b002d9140a6e41ecca6bd714c624840b8ed862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c25a67c4cc93c138ecfa98a6b5b002d9140a6e41ecca6bd714c624840b8ed862"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b88be58ceb0a02b832284b9d153077ac5d52e644941c7ea2a5a1cf8de082e4f"
    sha256 cellar: :any_skip_relocation, ventura:       "3b88be58ceb0a02b832284b9d153077ac5d52e644941c7ea2a5a1cf8de082e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2e27eefa6ffde6560c753c9372f02ef6c5d8dc5b78958b1c678b5425c10b71"
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