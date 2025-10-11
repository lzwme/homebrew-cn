class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "ff343ac3c9c18f6e93bd6c53bae50943677638e15913e10d3ed6e40ce23231d3"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be89a2cd30aed509e9a4a49f8dd4113edd6cca5b88d79a4f4bcea9c51f79c63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be89a2cd30aed509e9a4a49f8dd4113edd6cca5b88d79a4f4bcea9c51f79c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be89a2cd30aed509e9a4a49f8dd4113edd6cca5b88d79a4f4bcea9c51f79c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9547148282f0e78325467cf75dfd4713af1854276a95e281951b2ae6f346dfa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259f6ee63be73ce02948530c22ca16a3b98768c364945b5edf7c33ba2a4def6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce7621852d089e806aebcb9a3419ebabd09c2b208fb51c90dd15723fa00cef4"
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