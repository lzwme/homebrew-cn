class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ca97e577a12961b228822310527fc7bff7299392ac93729bdc45caa28966a1c3"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0f6a19ac48d79ebf0159d70d2d5fc451b460ffd0a28467ccbb85b665f1127e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f6a19ac48d79ebf0159d70d2d5fc451b460ffd0a28467ccbb85b665f1127e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f6a19ac48d79ebf0159d70d2d5fc451b460ffd0a28467ccbb85b665f1127e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c2b03b9c55ad8c0a6e893e4d05e5f1cb9b7b2e2eb8be59a8b64e3066a36245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd8a3cbe694efb7ff3a2c58c03aba274da48a32eb5d6ce081d0d4fba613bb08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ab44039fee27a3fba4ab7e4a13d96e4e95cf66b045f17dba28192304fbba73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end