class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https:github.comgithubgithub-mcp-server"
  url "https:github.comgithubgithub-mcp-serverarchiverefstagsv0.3.0.tar.gz"
  sha256 "3e7e3b8e6496d95e4913661e44665067bfe6874da016dc43b53e5f8beaad1a26"
  license "MIT"
  head "https:github.comgithubgithub-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04654215b56e0ab9153f4baa048ce0762ac361b39797b0920b1c1c8d8c1dd3c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04654215b56e0ab9153f4baa048ce0762ac361b39797b0920b1c1c8d8c1dd3c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04654215b56e0ab9153f4baa048ce0762ac361b39797b0920b1c1c8d8c1dd3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "98044197710393da960dc6d27f83d54b939e71ea033bea0ba0930875b7550881"
    sha256 cellar: :any_skip_relocation, ventura:       "98044197710393da960dc6d27f83d54b939e71ea033bea0ba0930875b7550881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd935cfe770e4882c92d0b4dc364d50e107e845791706b4a0dcc560d37964139"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgithub-mcp-server"

    generate_completions_from_executable(bin"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "toolscall"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin"github-mcp-server stdio 2>&1", json, 0)
  end
end