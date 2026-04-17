class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "eca9ffa34a8c70da5b681889dc9ae0eca464638838fcce11f8b4c5a199f02d1b"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95fbce23e4a8258b6cae95c7bec7320f81157ec31c5ed30ea142db8e9a9a773a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95fbce23e4a8258b6cae95c7bec7320f81157ec31c5ed30ea142db8e9a9a773a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fbce23e4a8258b6cae95c7bec7320f81157ec31c5ed30ea142db8e9a9a773a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c4985bdd1e02fba46a84c34afc8731300365aba14a9614fcc0b06969ef5e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36b20119f69fc9cd8b774f2fcb1d37f16b318692272a6cdaf0f67e49e4c77dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e988d731ed035d58db1a749efc35ac15aa09d780380799b1f9301fe2396107"
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