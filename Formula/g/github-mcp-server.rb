class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "1b9f07ac741a5fdc22affb43b5c5adc3933083180f924faa7fb679c7aec4ca78"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5390c8a4138787d1619e1fdf6d66c29c39d676a92e9078aeecee0274a4b0806"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5390c8a4138787d1619e1fdf6d66c29c39d676a92e9078aeecee0274a4b0806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5390c8a4138787d1619e1fdf6d66c29c39d676a92e9078aeecee0274a4b0806"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32e92dd4bd841d721f2b06e7cdd2daf6d7f42bd53d9cacfb3dd9e7cc65863220"
    sha256 cellar: :any,                 x86_64_linux:      "6e866083508bd091a9d73ecfd4958f8086658597658b6f18f4a1660770192093"
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