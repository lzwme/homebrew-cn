class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9d1e947afc54d047c345de468ca479ab835d7b9093689043d583008d51ba42d4"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d58de232253e1cf8b5e64e798085319b86a551e2149efaadef5b48f94145344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d58de232253e1cf8b5e64e798085319b86a551e2149efaadef5b48f94145344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d58de232253e1cf8b5e64e798085319b86a551e2149efaadef5b48f94145344"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2e69f8d3d9c8d47d810ccb0f63e875567a85ab1a01d2296c40455afe331fc9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12acd36d7aff44e8426f416f93375f8c3641f26f6504f5064f4c071096741864"
    sha256 cellar: :any,                 x86_64_linux:  "6eb8143e0e25598b5aeed0f1526c71dc5d666a991a43da55d2e446647080e038"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/github-mcp-server"

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