class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3c64fed3846871723a08acde181a941ce76106b5838181e11bb6fe2efe0a4037"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de26a844858082ed3a6799826709661d2cc8ed71a1118d4d2ee35bf920c22d78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de26a844858082ed3a6799826709661d2cc8ed71a1118d4d2ee35bf920c22d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de26a844858082ed3a6799826709661d2cc8ed71a1118d4d2ee35bf920c22d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ae3fb018f7bed897fb19d2f76a594cb73828b59ac1e992ce79fe78f49cd0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c2f10f2bf247c97f395567a0f1112b0164def1698c86ba474d269a364279500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb510b0721b05e6e1ac1d8e01bc9183ecb2168183d19b9461599a8338b4c77a9"
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