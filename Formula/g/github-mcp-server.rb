class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "efd8d39ce8c9841ebd9f67180bd36fd77786bcb3788fc44154b63a68580745f9"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15829029e285b7566ba3c8f9c5cc2211c85ee272481f40e27d9cd83a683cb3aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15829029e285b7566ba3c8f9c5cc2211c85ee272481f40e27d9cd83a683cb3aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15829029e285b7566ba3c8f9c5cc2211c85ee272481f40e27d9cd83a683cb3aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf5960eece7f156deb81dbdb6e0858fba0c07ca5eda5972ededfa5320124da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682497ece16b59f42ed657347899446abc36fda87d15202957eabf15e1bff637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809544cfde51dce0812ded8828cba7bfdb695c9d71099970de4e3e828e0c6ef3"
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