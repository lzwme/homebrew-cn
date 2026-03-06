class Neo4jMcp < Formula
  desc "Neo4j official Model Context Protocol server for AI tools"
  homepage "https://neo4j.com/docs/mcp/current/"
  url "https://ghfast.top/https://github.com/neo4j/mcp/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "b4a869343e75ba9db3d006d25df5513a709c72cf981e5a1a3f414c0035c5c9ab"
  license "GPL-3.0-or-later"
  head "https://github.com/neo4j/mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd3c959de552f1b368121b0b78e14ee64ee42077a2497d1e14ef3a6464aa468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdd3c959de552f1b368121b0b78e14ee64ee42077a2497d1e14ef3a6464aa468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd3c959de552f1b368121b0b78e14ee64ee42077a2497d1e14ef3a6464aa468"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b95ac371e974f249f0f48973ede44eb52c4e224f0d7374673cf3cf604c7c21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "973d7008f4af960574a8d367afebf2e46ceba9e24c1f1785964beffbaebd109d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55461d132e2cfe6d9d8fd266f3cd323d73f3c93dc4f54016d66494db98d817e6"
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