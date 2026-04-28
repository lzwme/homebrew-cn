class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://ghfast.top/https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "289a7b464d5f710687c52118a774b5c40945f26f45826ec85f602eba560a9506"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af800ff8546b0a299a75b51aa1ad1e9d14ec0238e87404e26b856bc63b4b57f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af800ff8546b0a299a75b51aa1ad1e9d14ec0238e87404e26b856bc63b4b57f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af800ff8546b0a299a75b51aa1ad1e9d14ec0238e87404e26b856bc63b4b57f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76db5d79e5a17cc9352ff5a2b3671534b9b1ef48021d06b91b5fb109db166af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577cfbbcb3d35b90fa5aa40cbc5988536e763b756903c57ecb04991d209be44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58cf803e8d5a151d16380725f913900f19277a9db511ec2b0b1ca2bf5776287"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end