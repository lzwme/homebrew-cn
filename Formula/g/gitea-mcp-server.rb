class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v1.9.0.tar.gz"
  sha256 "bd5928fa35de145d7c4ed95f60242bec74b30d254ef219547e035d6862a1add4"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff29d52690a58f1d5497a0d381e85588eb1c0b17c014bad5b941783f34490499"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff29d52690a58f1d5497a0d381e85588eb1c0b17c014bad5b941783f34490499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff29d52690a58f1d5497a0d381e85588eb1c0b17c014bad5b941783f34490499"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2730e75cf29e829ea521b34b7fa5040dce75d369700503ac882ca529642ee026"
    sha256 cellar: :any,                 x86_64_linux:      "e108dc0fe23d54d3b5344c7698d95feabc1d87ccb8168cd735b15a7f4a605650"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    # Read the reply before closing stdin: 1.7.0 exits non-zero on EOF without flushing
    output = IO.popen("#{bin}/gitea-mcp-server stdio", "r+") do |io|
      io.write json
      io.readline
    end
    assert_match "Gitea MCP Server", output
  end
end