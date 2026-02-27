class SlackMcpServer < Formula
  desc "Powerful MCP Slack Server with multiple transports and smart history fetch logic"
  homepage "https://github.com/korotovsky/slack-mcp-server"
  url "https://ghfast.top/https://github.com/korotovsky/slack-mcp-server/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "efac7f244c45250fd8165cd25c77559805d6c24dabaaa7d8f4e1b8ddc09f195b"
  license "MIT"
  head "https://github.com/korotovsky/slack-mcp-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb4eaa736ce2d4e036907b0e0c29e5106ddd8f96e3b078815348745bf448332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb4eaa736ce2d4e036907b0e0c29e5106ddd8f96e3b078815348745bf448332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb4eaa736ce2d4e036907b0e0c29e5106ddd8f96e3b078815348745bf448332"
    sha256 cellar: :any_skip_relocation, sonoma:        "e424325e147a2bb97d335e93ebfc653e25326b3096ed4c8653addc821909a1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3240e93fae2b81f8b7f52769663eee2b32f5e93364e30c1403697e08e01b7b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a60e7a7e1d7aaa740f2b9922219971747f910e78d4413427e800ff66b91b3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slack-mcp-server"
  end

  test do
    # User OAuth token
    ENV["SLACK_MCP_XOXP_TOKEN"] = "xoxp-test-token"
    output = shell_output("#{bin}/slack-mcp-server 2>&1", 1)
    assert_match(/Failed to create MCP Slack client|Authentication failed - check your Slack tokens/, output)
  end
end