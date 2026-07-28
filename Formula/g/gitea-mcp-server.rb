class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.5.0.tar.gz"
  sha256 "deddcb5438737a090eda3b7ed21c92e00a6217011ed5e6d6db735a3c80d44155"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf0a812bc2bb0a3afc9108936aff5aee12bbd70a514719b65201c5b76431db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf0a812bc2bb0a3afc9108936aff5aee12bbd70a514719b65201c5b76431db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf0a812bc2bb0a3afc9108936aff5aee12bbd70a514719b65201c5b76431db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a18a68f5d246437c966125571dbbd3172eb8616f99d11529a8d854e898ddf2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee0ceef176ddc18a2ae05e35db6d62304e1b635b045fd8a424afd6fc05ee4bb"
    sha256 cellar: :any,                 x86_64_linux:  "3c35e1697f12eed08cbe6017edc8a5caa4cb612ec9169fd095c625454a090d21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output("#{bin}/gitea-mcp-server stdio", json, 0)
  end
end