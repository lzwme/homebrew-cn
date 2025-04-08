class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https:github.comgithubgithub-mcp-server"
  url "https:github.comgithubgithub-mcp-serverarchiverefstagsv0.1.1.tar.gz"
  sha256 "626d0112467b1bfd76335f12f65a5b065ac09e441d7de48106667956f5a62f70"
  license "MIT"
  head "https:github.comgithubgithub-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ca5751cc22753d662de18c01d4b137220f3359ef7b8793f5aec851a2f44043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ca5751cc22753d662de18c01d4b137220f3359ef7b8793f5aec851a2f44043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70ca5751cc22753d662de18c01d4b137220f3359ef7b8793f5aec851a2f44043"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b3faa48e2d97e79cad328ab25afab4295906bb2c3d5956f992726a38cc5065"
    sha256 cellar: :any_skip_relocation, ventura:       "c2b3faa48e2d97e79cad328ab25afab4295906bb2c3d5956f992726a38cc5065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c9fcfb09efcf7ef3842d07d3cb34fdd132420659a4c436618652f5f2f8a282e"
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