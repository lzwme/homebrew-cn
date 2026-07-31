class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "df5cee6dfa31ae602016b65b4252cb7d691deef336c07691ada9861cc61a6d3e"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e5e1777619166788e76f0ae6c45e2aa69bd50b4d3241c7ac4b0c31a9640e4d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5e1777619166788e76f0ae6c45e2aa69bd50b4d3241c7ac4b0c31a9640e4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e5e1777619166788e76f0ae6c45e2aa69bd50b4d3241c7ac4b0c31a9640e4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd53af6fde609ae64221c421a11f5a1b2e8f13616550f6c952310d834a5907d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83b7a90f94786344e07158f64fc33298de1371dc4481ce2c517d3d2132ef74b"
    sha256 cellar: :any,                 x86_64_linux:  "19c6e5d52c8a4d66fc18ec8e01181e27ca804a18b8bded41a319e5021b492a4d"
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