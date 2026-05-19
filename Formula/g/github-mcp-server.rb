class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "f986278faf7fcd58a3386ca59ff5fb770cde5fb37389508199563ff40e5e81fa"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f8c98596d9934c77f418755898cd4ee8e9cfcf0b5993a0db806621911a5178a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f8c98596d9934c77f418755898cd4ee8e9cfcf0b5993a0db806621911a5178a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f8c98596d9934c77f418755898cd4ee8e9cfcf0b5993a0db806621911a5178a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba47defc89d4d5fdab5e3c173bb37494386ae9f487b3a4f86e598d1f1158630a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011c213ed0f1b374283a52afc272893e2448fa39476735913cbc88346a791d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91bc1df6e94ebf9a5ded096e37441a6eb9565b9520c35585e5aab82391f8f6a6"
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