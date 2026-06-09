class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "02b3865518fa189d066a14d81b891e939e93b60bb1723eeea728f4720d1a1e60"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d8d5537fad13de7d2843b0f7e6996f6e8631bef599e388b57f4c52b2659c1c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8d5537fad13de7d2843b0f7e6996f6e8631bef599e388b57f4c52b2659c1c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8d5537fad13de7d2843b0f7e6996f6e8631bef599e388b57f4c52b2659c1c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ea0c3cc4a6b94fbdfff2fe55dd0fc2af7467162ba504dd2f6a2c6120085202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ceb4cf01551f0df16a8388775b588e9eaa8ffd74ef93aedcc1e5cde65a8a6ba"
    sha256 cellar: :any,                 x86_64_linux:  "ebeeb28df59753131cf200eeb8cfb0c6702fd8dedc6c2298a78457027ca888c9"
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