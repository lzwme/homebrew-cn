class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.6.0.tar.gz"
  sha256 "fe15c3b984dd72e49e0baaf8175eb10c6266f647c3942eaaca2531e828872261"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4a2beed4821ef3634896b2eaf14cd18b2892421fc06a7ad9f707945c7d9741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4a2beed4821ef3634896b2eaf14cd18b2892421fc06a7ad9f707945c7d9741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b4a2beed4821ef3634896b2eaf14cd18b2892421fc06a7ad9f707945c7d9741"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc931b698628c3cbfd94f58edfe3ec7340423c1edcbe540abef0daf32a7bf08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b1ddf2216668b858e877d0fcda73e3eed9ff8cb61c274a65360d570a2dd94e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd702185817ec859807d3c41ef524f737935d90aae2dc0fe09d960e5668ef2b"
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