class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "0bfb8a505f04f699570db3a712aa38d31ca403b420a26fceb7dc9cad7e52a997"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e03907faa73a0ef8d6ba3210a283d2f6c3da8f37f11bb706a9fffae300e461f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e03907faa73a0ef8d6ba3210a283d2f6c3da8f37f11bb706a9fffae300e461f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e03907faa73a0ef8d6ba3210a283d2f6c3da8f37f11bb706a9fffae300e461f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3aa8a014f2f02197dec943eae70da5fa6baa42edb20e88972e7d574472c19f15"
    sha256 cellar: :any,                 x86_64_linux:      "d5ec8b9b327c1942f467f07c46c060081f25e648f89c0afd48971dc6ef95aac5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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