class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a4733278794e3001494853e301a1de217ded77078d57c4c381a65ad357160193"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc4afbc178c5dc7c490b7ae4936f22b21a72bdb1f63d68ef6d5248efdacfded0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de7e850efb6227174490562930a924a273144e05b42bb3eca046f02b31691177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e857da800b078291507bc767096e9969445bef15639862d8fdc7376d0d22e53"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af330308b011621b239f03723821afded3239f37e5a28d7ebca9ce5c768e18c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41d0fe895a6e30be30335f5a23642e9c58158e415c473ec4c1f79e7c14a03827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bce3d238b7390014833f03b68bdd4eb3e6cbfbafe2f3a0439ecebbcf91e477e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end