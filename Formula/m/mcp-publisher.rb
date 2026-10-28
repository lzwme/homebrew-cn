class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "ae040950959cbd94923c57540746b5754e4369c1c464d9af4f5df84dd0c45bf6"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2212f123b5c221c29c5566ccec3d6245bcaa7a6ec707b6d879d275ba67ab5a81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2212f123b5c221c29c5566ccec3d6245bcaa7a6ec707b6d879d275ba67ab5a81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2212f123b5c221c29c5566ccec3d6245bcaa7a6ec707b6d879d275ba67ab5a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50289eb7edd78c612419191f00e2331c4d3d1185562931fabc89b996dc249022"
    sha256 cellar: :any,                 x86_64_linux:      "00ba93730b0fe272f359f4a7ff041076c8f540e43c1c784a92bea4654a32d2a6"
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