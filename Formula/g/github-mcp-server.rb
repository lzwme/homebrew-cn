class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "a826cff7ea6d895ace93836c5f3d453fed86ecfb607abf3957e235bcf391ae28"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07c71078fcdd7dd02b1d65fd5b9a959f8ed8e22ecc42869d89f57916a78b1d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c71078fcdd7dd02b1d65fd5b9a959f8ed8e22ecc42869d89f57916a78b1d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c71078fcdd7dd02b1d65fd5b9a959f8ed8e22ecc42869d89f57916a78b1d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c8560fd04eb640a118fb56e403c541f38a9f30617d4743cb0d79bb8e148603"
    sha256 cellar: :any,                 x86_64_linux:  "b90515b620bd3b77f74d36d09da208234e118fe65de8edd36c4d00ce2a126043"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/github-mcp-server"

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