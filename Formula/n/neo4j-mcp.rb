class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ae622058f73f862162b2a0c51f33b3f50ae972844af3218c62ae7136e864b5d2"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4653e1c9c0371dad6334d7ea51a7e427542e0c9a0fdcabc4cb559b899892e15a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4653e1c9c0371dad6334d7ea51a7e427542e0c9a0fdcabc4cb559b899892e15a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4653e1c9c0371dad6334d7ea51a7e427542e0c9a0fdcabc4cb559b899892e15a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e66bedaf4466a34ae710406c8c3b361db1c06b698718b6ece9aa62d74671811"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d300cf80367db388b918f5be88ddce3d1563cdcf82a0025091964ce5841482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae61bebd506468e003c70d96178e11650f26d9c3c011807d7add7cc61d56815b"
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