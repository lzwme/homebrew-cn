class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "f222ae3d21df87835dab6b41bbd3195e32b924e317730378940e24f57e5c9f78"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ef5d74a7edbc479d6536f6315fbe5fb376e2b934b63a02b3e39beadb0087af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ef5d74a7edbc479d6536f6315fbe5fb376e2b934b63a02b3e39beadb0087af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ef5d74a7edbc479d6536f6315fbe5fb376e2b934b63a02b3e39beadb0087af"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e98d0945e8f510f2f60764259e373de807154ee0a3afaffa50fc634a2f0eda5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f767f17a7da5bf4f0f5c33fdfd3b161af868c0a8162ae8933307890e79d993d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40cf249487bf0dfa426479ff1cb36032b54754bca4c916838ceacb860973d8d5"
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