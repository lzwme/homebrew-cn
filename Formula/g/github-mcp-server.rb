class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "de379aa3770a000523d56f619729587043330126a7f89eea629ec897b542da58"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe76bb6043e8874dc148ab8240a8466a05dd9235f2842f212e446dfa4d37bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fe76bb6043e8874dc148ab8240a8466a05dd9235f2842f212e446dfa4d37bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe76bb6043e8874dc148ab8240a8466a05dd9235f2842f212e446dfa4d37bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b81fd53406f40e7cb0e7ab34b39de2021b6d74e9edc53fc86d46bb34880401"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08be336f31cb804304d6a806da97548f6879f17185b95703eb0dfe8a305551dd"
    sha256 cellar: :any,                 x86_64_linux:  "5d53137f9869a84532725c9d9d8049a279aff8ac61fc64bc2ba20044ffe4be85"
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