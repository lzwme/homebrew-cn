class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "b18995b4cf8aa373778291f8ecedfca3b22748e579e0c2f97947f951a37fa58b"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178b1300cdf4f5d4e43bbc0a716031a428383a0810e62d7ebcf6fdf29af19d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178b1300cdf4f5d4e43bbc0a716031a428383a0810e62d7ebcf6fdf29af19d94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178b1300cdf4f5d4e43bbc0a716031a428383a0810e62d7ebcf6fdf29af19d94"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd4af37c8a2f8ce71d9bc7665675c5aec5b0a79ca135d616c29df919ac4720e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3557ba9ee2fa3670a38e3c4cfd1734cfec80d8dfbe067a43d1a0223502d3bcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1248e1ed0b576ca447aa90bcdfc14ac32bf9d629c15674efcb1c017be9cc98dd"
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