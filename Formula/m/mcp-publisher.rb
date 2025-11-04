class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "2e0f45535691c19c2b79a78fe5edb044fdcb4d786f3eaf0434b102a6391ae02c"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1244e99b0d2917ae59165a8d5fa50c2991d2fe8cccbdf51cf65f8c7ea79c464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1244e99b0d2917ae59165a8d5fa50c2991d2fe8cccbdf51cf65f8c7ea79c464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1244e99b0d2917ae59165a8d5fa50c2991d2fe8cccbdf51cf65f8c7ea79c464"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1446da8d424166ad4f3da396f51c63d8a87b8bce362d9ce303c12f06edab51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010253be42c4437c1098c5e4c557300b51c4b8094e15a442e52081c74b59f8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3ab6fdeb16578e954071c6f0e63ccfd0526692e6eee235fc6b51263abec608"
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