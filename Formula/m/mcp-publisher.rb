class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "cb86e3df3a8d653418a2eff9b659c5034db9024e185d5908a40a5a4b6d470962"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebd820011e6a761504f546d8fc11a120a3307add60ad1f4ac75b89201be2b886"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebd820011e6a761504f546d8fc11a120a3307add60ad1f4ac75b89201be2b886"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebd820011e6a761504f546d8fc11a120a3307add60ad1f4ac75b89201be2b886"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba08a8798bd8ca1e458f5c8d0d94c6da1d0769a6ef8ac7d5dfa7e23589914fb5"
    sha256 cellar: :any,                 x86_64_linux:      "de5dc239fa8374ba6ba8f1eb647d16b7925ccff53b6e3df6df9d25a7f8b6dd11"
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