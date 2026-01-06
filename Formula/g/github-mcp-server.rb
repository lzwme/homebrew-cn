class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "97ff67ccab6513592dab4d4c80d5aa0ca0d30459a466784187946520c30bdcc6"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feae76a880ede366d00805f5845c44904388b048aa876703e97614cf3cbd7c33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feae76a880ede366d00805f5845c44904388b048aa876703e97614cf3cbd7c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feae76a880ede366d00805f5845c44904388b048aa876703e97614cf3cbd7c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "8998fc0eba52af301d781a6d4a7337258639d547ed70c4f510c21ed9099a3daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d13cc74d9ba7fb35dac8c6c56a7520beb3755651c3fbe96364c0700363a7396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4850920415eaacb14fc8733976c9de1738cf859d0d133cddfa7361e770220c33"
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