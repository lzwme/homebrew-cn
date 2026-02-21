class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "6425ca5f1fc61bc69d4d02065f4db10056f784fc6bda4dcc124901715278657a"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ed241333501d9f8364fbb5bb3445c815dbd06656cdbf2e544b07e81accba2d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed241333501d9f8364fbb5bb3445c815dbd06656cdbf2e544b07e81accba2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed241333501d9f8364fbb5bb3445c815dbd06656cdbf2e544b07e81accba2d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c62ff33e0e36dcd67d59f8b889ece71b018a4ef63983f5c82b516332de62a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb54e0820b81eae21ebe574e624dc4fd8d05598feddfb01b83d24ab8ea388e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16158c4ef0a35b8eb0fd9b0050c152e0ece82408c742fba663f5a088a13b8ba3"
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