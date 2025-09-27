class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "f959b444b0da57c98eb3c2cccb2af65b83fbfa9a34c950e6fbeb5021ee753465"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8dc945d52e853f08ff47475a152dd70d6c0ad8d15712ef658a84bf0870a0dae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8dc945d52e853f08ff47475a152dd70d6c0ad8d15712ef658a84bf0870a0dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8dc945d52e853f08ff47475a152dd70d6c0ad8d15712ef658a84bf0870a0dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "efdf0ac1210b038205605cc64677df644d977f2cba6ac399a740063333ab5ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64df1d864ca3008389ae51c326d3aa0f96bb6c4bbf124988a4c753010b71fef"
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