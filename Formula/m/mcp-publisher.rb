class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "83b376f7c3a7aca93d2999bfbdc3e359934022fd02169c8ddfe1584ae37542cd"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0256d761141e567444f71ea0ad4e38822e677b001f1899b4a7003df1b47feaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0256d761141e567444f71ea0ad4e38822e677b001f1899b4a7003df1b47feaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0256d761141e567444f71ea0ad4e38822e677b001f1899b4a7003df1b47feaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ba176a0a9fa00a412bcce380d0ea1fcec1339611bc02df93e900f7c50b963f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8604cd7cf5b4d10d08cdcce9af36822cf088156460533b9c611df44b7e5d486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7caa52d7c1883a01229e99540555c99c82c6f038c3314059b2e035788ac9959"
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