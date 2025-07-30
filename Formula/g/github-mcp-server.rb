class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "a5e2f13cbf2223c6c2e0bce6d842f9f05aa1f8c291c0518fca8066d10a5c25a6"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51717f234e4e812610e1a04862348da855f8778b1b5533eaffa0f99a41cd49ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51717f234e4e812610e1a04862348da855f8778b1b5533eaffa0f99a41cd49ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51717f234e4e812610e1a04862348da855f8778b1b5533eaffa0f99a41cd49ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e75f4b880894b973be9ab6630b08f9a1538b66475ba127c61c58ea522612f18e"
    sha256 cellar: :any_skip_relocation, ventura:       "e75f4b880894b973be9ab6630b08f9a1538b66475ba127c61c58ea522612f18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6a7e65387f291b6d332698ff14ce94b1b5fa5c198d47a323e7ec85bdb7dde2"
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