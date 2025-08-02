class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "315038dabace7a414c97cfa93293e3feaf7c699f78866175b4ae2b5c191f514d"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc65acc8187353a0de8ed283aaf417a1bf7ff0a90e13257fd00dd19635c5bdfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc65acc8187353a0de8ed283aaf417a1bf7ff0a90e13257fd00dd19635c5bdfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc65acc8187353a0de8ed283aaf417a1bf7ff0a90e13257fd00dd19635c5bdfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2954925b08b70e01cd2e233e6b1a437a394ccfbc15606f0252c467a382cc5a0e"
    sha256 cellar: :any_skip_relocation, ventura:       "2954925b08b70e01cd2e233e6b1a437a394ccfbc15606f0252c467a382cc5a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58d19f36d640c90faf10820ea361b1e56c0e057f543ed6f8463055e1742e64b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "tools/call"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 0)
  end
end