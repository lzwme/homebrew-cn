class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b1e4238156ab069967cd8ba31e6750119e90bab80027dc624dcdbbcb817b22d9"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05357a981a81d3e283b7f11c4e0fdf0b04f54d3f8be9209a2e0782c912717242"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b580c7b1e0f731d841369d58fd3cd885ed3431a0b90018b6b9a45438dfb4680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b289de70d45f36417e4ca35a062e1f27987eb55cf4d5c6232f502cfaed754c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "3867ff7403081ea8715fcd44f7190cc832e0cd3ac58b4a366c7f951d26a4a722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0f45a0249cb1fef039f82d9662e95c2c3b3ee63ecf4ff2f4c4c29afef01506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390ecbd017d185a5b8bf024a91820a3cc6740043c959e484a84f5853545414e4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "plugins": {}
      }
    JSON

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "protocolVersion": "2024-11-05",
          "capabilities": {
            "roots": {},
            "sampling": {},
            "experimental": {}
          },
          "clientInfo": {
            "name": "hyper-mcp",
            "version": "#{version}"
          }
        }
      }
    JSON

    require "open3"
    Open3.popen3(bin/"hyper-mcp", "--config-file", testpath/"config.json") do |stdin, stdout, _, w|
      sleep 2
      stdin.puts JSON.generate(JSON.parse(init_json))
      Timeout.timeout(10) do
        stdout.each do |line|
          break if line.include? "\"version\":\"#{version}\""
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  end
end