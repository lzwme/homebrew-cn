class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "eb300417bceb8aa1fad60d9d8b4c8f5609754a5e98bad9892f50b251d6f632b1"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d5eb056ff06b7998fc4e284c373d271d275dac66311cf0e5ad92297c4ac7b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d5eb056ff06b7998fc4e284c373d271d275dac66311cf0e5ad92297c4ac7b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d5eb056ff06b7998fc4e284c373d271d275dac66311cf0e5ad92297c4ac7b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a62b1ac9f4ef74d38fc6e55295d96ccf3437e43be80da8798028c75f8842de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7fe2ab8c0a4f12fa90fc844c6d38d6dd5abd3e0714ec45cb4ad372e84176571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d9a200e3026924945622c61084223ffe494fc9b1c9bed03d6c52f1ae6b594c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/neo4j-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neo4j-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/neo4j-mcp 2>&1", json, 1)
    assert_match "Neo4j URI is required", output
  end
end