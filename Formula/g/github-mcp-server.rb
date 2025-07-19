class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "03d827785ee4b68dce0b97215e0f8f1a87a46df584d35109156d8058cab1526e"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c54908baf35f2adbeb31c28ee67f11a5776b77b81dcfe1dd0101d2a1794be069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54908baf35f2adbeb31c28ee67f11a5776b77b81dcfe1dd0101d2a1794be069"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c54908baf35f2adbeb31c28ee67f11a5776b77b81dcfe1dd0101d2a1794be069"
    sha256 cellar: :any_skip_relocation, sonoma:        "28be78c85481020e0f2b477f647ada8edc66ad2598bea97a29a878d246a35803"
    sha256 cellar: :any_skip_relocation, ventura:       "28be78c85481020e0f2b477f647ada8edc66ad2598bea97a29a878d246a35803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbbba95ec5cd0c9db71f82dbb04d2e858e1d6f30a4380c59a71560c32e7437cc"
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

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin/"github-mcp-server stdio 2>&1", json, 0)
  end
end