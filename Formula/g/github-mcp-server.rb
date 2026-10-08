class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "2b0d5e58685590001a5b39b1d75a672a1858dcd4b8c53a33f4682b2f26fc83fc"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e7925b68518db472d3c1496cd9774402bebe48c2349714e1e67a75a5ae98706"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e7925b68518db472d3c1496cd9774402bebe48c2349714e1e67a75a5ae98706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e7925b68518db472d3c1496cd9774402bebe48c2349714e1e67a75a5ae98706"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "017885509cf6e5f316f59a858cef3c78fcc676b968fbb97b0f124fcc40268ba4"
    sha256 cellar: :any,                 x86_64_linux:      "792e1d78a3e368d5f6760675ca9c3d8f71170f73f92ebe9bcd49c895040ae2a1"
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