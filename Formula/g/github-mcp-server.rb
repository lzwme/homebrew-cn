class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "aa3400f2677fe3f8443b496b9028c48d31429db17de7397bce9de1ff7cb21b13"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419830389d911f1c13ff859cb9ed03a85e53421272edfd92e874c46fab796180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419830389d911f1c13ff859cb9ed03a85e53421272edfd92e874c46fab796180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419830389d911f1c13ff859cb9ed03a85e53421272edfd92e874c46fab796180"
    sha256 cellar: :any_skip_relocation, sonoma:        "902c0dd5c7109ab9b4a20f4a35375a9c4a25c2da939f734f32cf27bd4f96d977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8e0d61635724391b1b1cc407fb8bbff4294777c0c06daad619c04a00d5d6a73"
    sha256 cellar: :any,                 x86_64_linux:  "be4c86b14a31752326db9d5b3eadfe620626dd1e323181cb58da0345f92d76df"
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