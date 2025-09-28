class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://ghfast.top/https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.1.24.tar.gz"
  sha256 "35be4864d87578cf6dd730b953f65fe35b057d8a90b8dd0ab42d294cc7b38db3"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f11bf36a370918782d35efe1dbc0cfcc8ed404fc55649854aaa1ee8ac2c16654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11bf36a370918782d35efe1dbc0cfcc8ed404fc55649854aaa1ee8ac2c16654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11bf36a370918782d35efe1dbc0cfcc8ed404fc55649854aaa1ee8ac2c16654"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f4001ed3880c8b549684c128168cc140b94159caaf482052da21a91a953f598"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2384d7c64eae3e1bbda6fe7bff9dcaa64c458b17a6368d680cfffb172b22a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a95059aa62c57f04942a710c120fe9e85abf1e6464fdc488b35f7e11050149"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    assert_match "Failed to create MCP Slack client", shell_output("#{bin}/slack-mcp-server 2>&1", 1)
  end
end