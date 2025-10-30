class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "9ef6546d443f8b0fc08705e0ac048b72236855ceb484423e953835f7b8866f79"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60865ad5bf91a806deffe1bcd648178caea86dc6057af6ace1e1db44c2a8a5ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60865ad5bf91a806deffe1bcd648178caea86dc6057af6ace1e1db44c2a8a5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60865ad5bf91a806deffe1bcd648178caea86dc6057af6ace1e1db44c2a8a5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5461216e5db944a012b07a4fac8c90b598818b621483fb2866e6997ba886b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be027b837d4dd80c95fcc40da741317fc1c865581477e2762b2a834b96ef6078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c33653b79eb58d4cfc4e85597e82c891c13380053523489150cf27128ae41fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end