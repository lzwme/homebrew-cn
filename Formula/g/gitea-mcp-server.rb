class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.3.0.tar.gz"
  sha256 "7f0bb64d2713ab90b382f52e845f1b5406db9fa5657dbc3e21a19e1634ae77b8"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e5f80da0850be068bdaa277df568ffe4b8e5051c282081c3bccfad3e23fa53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00e5f80da0850be068bdaa277df568ffe4b8e5051c282081c3bccfad3e23fa53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00e5f80da0850be068bdaa277df568ffe4b8e5051c282081c3bccfad3e23fa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "a43ea1ac727ae983fc085214d17eafd7c7a16a2401665b069d2bc91ae0ab9408"
    sha256 cellar: :any_skip_relocation, ventura:       "a43ea1ac727ae983fc085214d17eafd7c7a16a2401665b069d2bc91ae0ab9408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0372e6b26def9b61b77258e0e9a52061a2d708347a2d28eea961f97a7d76e2"
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

    assert_match "Gitea MCP Server", pipe_output(bin/"gitea-mcp-server stdio", json, 0)
  end
end