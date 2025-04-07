class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https:github.comgithubgithub-mcp-server"
  url "https:github.comgithubgithub-mcp-serverarchiverefstagsv0.1.0.tar.gz"
  sha256 "c390bcf344802f8ac81c65e5fcb72b9c47dba4090cec1bb08698311e334d399b"
  license "MIT"
  head "https:github.comgithubgithub-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b12e2c4b32871e8241c09948c1d0ce05a846c5fe9cafba7c0a40f7304b34a85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b12e2c4b32871e8241c09948c1d0ce05a846c5fe9cafba7c0a40f7304b34a85d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b12e2c4b32871e8241c09948c1d0ce05a846c5fe9cafba7c0a40f7304b34a85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd2b8a16a9e8999dbf8e81336b0d5fcaac2131751b37346552dabd8f45a0a05"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd2b8a16a9e8999dbf8e81336b0d5fcaac2131751b37346552dabd8f45a0a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6ad198b094bfa987704270f64036fe3795cee439f863c97fc11c885d84c90f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgithub-mcp-server"

    generate_completions_from_executable(bin"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "toolscall"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output(bin"github-mcp-server stdio 2>&1", json, 0)
  end
end