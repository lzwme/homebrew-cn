class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c1a59707b47e0daa25d6ad5c26c78824be0e0558c519671f68290e54b8840ddc"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "084f261bbeebefe2fa9d7e10354e2382bec0dc459f7912d2c5572cab91885468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "084f261bbeebefe2fa9d7e10354e2382bec0dc459f7912d2c5572cab91885468"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "084f261bbeebefe2fa9d7e10354e2382bec0dc459f7912d2c5572cab91885468"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a397a2b001069983d89aa45116a87eccb0860101a9e8c83ca7b5fc9d5ece9a0"
    sha256 cellar: :any_skip_relocation, ventura:       "8a397a2b001069983d89aa45116a87eccb0860101a9e8c83ca7b5fc9d5ece9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a74e69df7b75c08e89ea67ffdf33669508789de82ecabffe2c79e707291770a"
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

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin/"github-mcp-server stdio 2>&1", json, 0)
  end
end