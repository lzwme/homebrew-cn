class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "220072144122d6983c2095ac7125a3b316b7ef2416f7a8657ef6ac99a8604d24"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b9f08a132c733d3c6fc3ba79dd90a7a5da28a36fa86650eb381cab5829e136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b9f08a132c733d3c6fc3ba79dd90a7a5da28a36fa86650eb381cab5829e136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b9f08a132c733d3c6fc3ba79dd90a7a5da28a36fa86650eb381cab5829e136"
    sha256 cellar: :any_skip_relocation, sonoma:        "528a6674cb8993fdd794bd6c88c9bdde37f461d67999ab5cd895f7f77aadd23f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb07d7aad07560d10a575981919f031e511a9d789aeaf8adc458c5f1334f47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d166b5ffeeac3521cf0fdde8f5b4e932e1be8c6aa4aacedbe49c81f63d454f"
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