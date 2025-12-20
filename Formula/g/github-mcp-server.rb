class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "a925eb758a60092ed3eb7cd58ec999c0a30dade37d034cae11c48f6fcb8c9e5f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5edfac8ad816135f623279ab49d427da88b29927237d88637d8be453dd77f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5edfac8ad816135f623279ab49d427da88b29927237d88637d8be453dd77f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5edfac8ad816135f623279ab49d427da88b29927237d88637d8be453dd77f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "05dab68bffbf06e081ed3a5694c2fc43722f9b51b52783986d3284da5dbd2cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0a7b3be5a1cf03b440252d2fb5ad7e9446ce03eaf997c53a87aec7192ff6341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32344d0a30062ee9a637eedaf61ea6def0b72f04ad105edf80dddedfd6b642ce"
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
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 1)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end