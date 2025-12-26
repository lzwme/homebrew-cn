class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "a925eb758a60092ed3eb7cd58ec999c0a30dade37d034cae11c48f6fcb8c9e5f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1917effd721372ed64a86731b4bf558a8ade562292c0fdbc072606c73edfc564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1917effd721372ed64a86731b4bf558a8ade562292c0fdbc072606c73edfc564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1917effd721372ed64a86731b4bf558a8ade562292c0fdbc072606c73edfc564"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e52edc865f3032fe8617cf6bc11a0d2554f907b08fcf51ce62e27a28177ff01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b463752f1cbcf2f98b30f5b038973b676d891e7d3a3d21c6a437020a6f61432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d92cf534bf413426496956fc4f1d428145cc09720ec396b6be48fe2bfd6ed8"
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