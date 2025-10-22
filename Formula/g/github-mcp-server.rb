class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "276d9814cdefb851f447df00c4f26244aab15ca6d1cf7a9ea3f9a0b481692587"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bedba2a0e60598983a8d604b1be47d7874eb272b5495db7f60d03faa0062f633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bedba2a0e60598983a8d604b1be47d7874eb272b5495db7f60d03faa0062f633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedba2a0e60598983a8d604b1be47d7874eb272b5495db7f60d03faa0062f633"
    sha256 cellar: :any_skip_relocation, sonoma:        "80571472bf456d51caf6ebaa4cd5a19bb97993cb74af61a2d263f8e45feb49be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b402b4eac305d3f2ba6b2ab882f8a90b1c7ccac41655aab0de826e31be495bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31ec9980686b88fd63749d028f0a74d9c2095d608594974b80956b452a31fca"
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