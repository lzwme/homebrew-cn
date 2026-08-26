class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "92ecb1619fb4c1970658be4b44dabd3445071fea70fae6d5b95284c4223062cb"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64883cf129da0d6a96aacff6d99d07633845e4b7a108c69737623a5825a22785"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64883cf129da0d6a96aacff6d99d07633845e4b7a108c69737623a5825a22785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64883cf129da0d6a96aacff6d99d07633845e4b7a108c69737623a5825a22785"
    sha256 cellar: :any_skip_relocation, sonoma:        "654aaf3ad9fc3a8df11266460d71e0854b4b1d7bc3b97c8d81ac7e0fce93afb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0c3efd1eea6af7c03eb28d5330f6499acad2144f2b96759b4867c9264fc1eed"
    sha256 cellar: :any,                 x86_64_linux:  "198f189fc46201638b0b9b8e56c1c846e72565decc2420fc2433f83cae8a6966"
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