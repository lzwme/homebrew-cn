class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cce31497ca66454a65cd8cda7f0bab3a324ba5f1d0343a3077ad50df158f008c"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818a13e5b7e50c31357e4a6b1adad9431b3bcb200bbdfbce110ec8448952e7a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818a13e5b7e50c31357e4a6b1adad9431b3bcb200bbdfbce110ec8448952e7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818a13e5b7e50c31357e4a6b1adad9431b3bcb200bbdfbce110ec8448952e7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d540664c4eb332628d08d2623a6e46cb8c8d2c6fe83815b0c54be70ec7c94b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec5ba4c2c223ae638d1c06e5f8d2bbc7628d69eacf025ec626a097fae9d47b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5869539b76d9a14db22cda022272e072804876c6cd49129f202a008688a8ecd1"
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