class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "f17e4f5d8568c2ddb04ab0b35588bcbf71e90c444768ec06ba8b9f6e4ae985f6"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50449d8b593c07e885066a55dde785e7b13e7a32933ce700701043112549c9a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50449d8b593c07e885066a55dde785e7b13e7a32933ce700701043112549c9a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50449d8b593c07e885066a55dde785e7b13e7a32933ce700701043112549c9a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a62fe3ed60616e9e1f20b3aaff358a694df48219bda783ff5c9fb7f3af466fbb"
    sha256 cellar: :any,                 x86_64_linux:      "030e3ddf5a209343cadde43a02daaa39f91e93ff95a3fd2982f6fcafe1707b83"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end