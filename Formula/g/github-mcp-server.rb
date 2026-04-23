class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "3e3b84ce19fe6138bc74f8ad338e2de18c72614d5dcf09a702f8bd37b6b6cddd"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d15ef7f7256da792a2f606f8c1b967465038903e63fb6cdca0d922071b19c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d15ef7f7256da792a2f606f8c1b967465038903e63fb6cdca0d922071b19c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d15ef7f7256da792a2f606f8c1b967465038903e63fb6cdca0d922071b19c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "55f01b5794a715bda46abc380f1ddf2acd92610c8166c159d3d6f7426dcb0aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e246e6a1e9f788829f48e5a1c0a63bc23adafc7fa0c5a99cc8ffb689bd9a7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57021f0e0f67463a63e6d22a16041e84f581b0dc45175c6c213c84b2b31495de"
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