class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "af1af38f36add27dcaa168840918e99373af8173ab0688a67c7c025780288d6e"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33733365a341355902e888f33f97cf5a2c5204e1229112e2ada6081e814f510b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33733365a341355902e888f33f97cf5a2c5204e1229112e2ada6081e814f510b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33733365a341355902e888f33f97cf5a2c5204e1229112e2ada6081e814f510b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f01206a72f6ba4548a713afa362e6f2e03762b1859a9d37bc07a5e3beca1ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d873a4b99c7656d59de2922959c5d64ecaef1e9aa53b35e9fbc6652a8031d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce45dd75790426afb099b4eef554338fdd96fd9571158995e2a9e4eab3c8fbc"
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