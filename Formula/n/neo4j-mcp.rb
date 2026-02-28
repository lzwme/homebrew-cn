class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "b349ad5ad44524a1b13e69204c99ff8e3b52becac9c2af9a68505d6c45a105f7"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a4f77df639b7074a3081ef19df4971f99e231a1ccea181e598a21197024ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a4f77df639b7074a3081ef19df4971f99e231a1ccea181e598a21197024ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a4f77df639b7074a3081ef19df4971f99e231a1ccea181e598a21197024ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0683bf8cb382215ecb4000e1205426f26b03189a5d633c20d7aa0a466e4cec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc790ea9208f9ad09881cc4b55c84bcbc839f3175612635115b40370458aab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755632611c33011e8dfabda733437e52d98ad2f5052a555387080094c751e77e"
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