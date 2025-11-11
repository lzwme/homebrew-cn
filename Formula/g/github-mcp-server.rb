class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "247d39076abef30022d956a19beba42c20cf8b52795766406e3eb0c095c442d0"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6c19d9a460e7191790a937223374044df3f516bd9d2f642b56d1917fdbc2c13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c19d9a460e7191790a937223374044df3f516bd9d2f642b56d1917fdbc2c13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c19d9a460e7191790a937223374044df3f516bd9d2f642b56d1917fdbc2c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b8e3d99604cf31322b17e720bfd2ae39dbd96ec3016b781139e98fe9e667f8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce01b114f3b55946e44e69681b3205fe0079c9ac2a31216a58d0d443a3c522f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802dc46ed8331bf321ecd3a48d7a2071f2afaa6b5c3664109dd5f7f30adc2b0a"
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