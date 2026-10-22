class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "08fcf97548428394e3262c52a0def70d317963ac81f6633816c409b8efd04387"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e743c124447f34d7280e8cfb9813c3dbd79c213a506796d924366fb37b28126b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e743c124447f34d7280e8cfb9813c3dbd79c213a506796d924366fb37b28126b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e743c124447f34d7280e8cfb9813c3dbd79c213a506796d924366fb37b28126b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c011ca081676d557c2dbd0d3650241016a8fa8698f634635ae84caa1ad27faf9"
    sha256 cellar: :any,                 x86_64_linux:      "20e68abd26e1290aea44dee26b7606b50461681fd243ff67b3360dfc6c3bed61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/neo4j-mcp"
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