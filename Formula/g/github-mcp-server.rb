class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8754d2f5fa41ecd8ad55f803030d09c28285c9a746f92dbdbe69ede473532a6b"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4fea8f656bae73583d0b985eba211f7ea68a64d7ad245b2bd0972047d211918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4fea8f656bae73583d0b985eba211f7ea68a64d7ad245b2bd0972047d211918"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4fea8f656bae73583d0b985eba211f7ea68a64d7ad245b2bd0972047d211918"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ed7cec6b768e4753f07af53bdba00df2dae7e5d5d64211a9b5548a67e204918"
    sha256 cellar: :any_skip_relocation, ventura:       "2ed7cec6b768e4753f07af53bdba00df2dae7e5d5d64211a9b5548a67e204918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22baeb0486c68177c56b8a3f8f9d24bf1ee01d6ab49536a53826fb53d5449e37"
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