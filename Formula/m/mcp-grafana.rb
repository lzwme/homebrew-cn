class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://ghfast.top/https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "b42ab6f91952301e2624a9d0e7ed7734b517d357050cd4d2d426665985acbe29"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc825abf2625da93d7d8dcd8afb205ff410246d59a5d5b9d6f025358a8cd1a22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a6bbbdb463d7901116bb357d353c0fbcb75887e4c814b473e6015850787b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99706ec1edbae7f4dbd5764d6eb5944a29ca00e56d166232b0713d5e6e8f144f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68bfd99aea064cf5484827ac1512a820007f966518c56dce7ad4b8714ad5a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "000aee0e5f7621cdc7e6015fbfc4a8a59049dc81fcf8c8d02da01911f85cae94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ebc29eea07e57644ec739a0d27c6e34f8516d9bf5aed92f082420f276ff50ee"
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