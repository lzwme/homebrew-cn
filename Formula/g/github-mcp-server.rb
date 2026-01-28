class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "5d81936768256bc1baf7a8cf191282fac94334b4e845365af9a01bdb183ab14f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27ed850367150aef0ee14dc6a2516a866b9d8dfdeb61960e9de0fd27721d60c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27ed850367150aef0ee14dc6a2516a866b9d8dfdeb61960e9de0fd27721d60c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27ed850367150aef0ee14dc6a2516a866b9d8dfdeb61960e9de0fd27721d60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6c15277a25fb1ce6801e3ae911627e56708c1cd6535f4cdd07fa6e14ebe652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78241eaf6484ae5d43e1c261f704631e398ffa9015bb5591b36e0a81fab89c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22032e8da7cdc1b4a07b8fafed35c97ee0a1ad70150300f61e864c92f7651b33"
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

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 1)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end