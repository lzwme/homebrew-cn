class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "c138f7e9ef58ecf1808f846745d83d492092240dbc43c7f48a586bf6741cb4ee"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d62a49440ced26e1bf1c3a9455a4f66d3208e761f777c4c98e18f8bc19c8063"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d62a49440ced26e1bf1c3a9455a4f66d3208e761f777c4c98e18f8bc19c8063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d62a49440ced26e1bf1c3a9455a4f66d3208e761f777c4c98e18f8bc19c8063"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "787a8837cbc8facaac6a95c940aa941933ff04a4277bf504055d97f3069f0dfb"
    sha256 cellar: :any,                 x86_64_linux:      "ff783548eab6648d98f2fcf96b60a208c93bbf7939318538fa81f8d19bf0b700"
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