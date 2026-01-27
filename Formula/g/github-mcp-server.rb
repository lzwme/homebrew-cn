class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://ghfast.top/https://github.com/github/github-mcp-server/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "8746bfc3afd9ef874186fde33757168803c067308ec43e3ebeaf30579f5eefd2"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91fdf35c3ea9fa286692907daab28e61d37052df6bc609815dfd4da00c0fb7a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fdf35c3ea9fa286692907daab28e61d37052df6bc609815dfd4da00c0fb7a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fdf35c3ea9fa286692907daab28e61d37052df6bc609815dfd4da00c0fb7a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c30e01c418d0e9619eb9396f377a06ce08b74abd4d6d435ad08963c12c470f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d06c39ff3da75b3deb1b08e30b51da21edef465aecc90978ab2cf1b50c313f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874a8996397c1aeff321b69c92b344901fee38a4caa2392a332995c671c21467"
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