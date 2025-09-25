class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "31033a7637030daeedba91c3833adca50aba240f32dfec0559c268d36dccc46d"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3db8ec98b49488c8c6caf2e067c553d5c8982bba05fec9c822e234ce6024cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3db8ec98b49488c8c6caf2e067c553d5c8982bba05fec9c822e234ce6024cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3db8ec98b49488c8c6caf2e067c553d5c8982bba05fec9c822e234ce6024cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2289b8df8e2ac3291b07c370e32c892c13c5fcf446458c2e8bae83f50c237a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9962bba68b9361a64ca0059a5d33d257c7d51badec9cab1190c2d20a62eaa4d7"
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