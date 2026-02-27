class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6da23d30d38e0be0b07711f1562b378ab7bc3f679e3470822ee81a86f9a40362"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dcdd293bad6b385d5ee9bf27000417f5ca362545d8c6be71bb90667fb3bc0ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e37e98ad72dfbf7f50093d19c79367e58b75272ee5271709b00bca88cc59006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860db71140622a6f2fe97279ccd2ae853d9a7c3476fb46a8703be013abe513c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e27e76dfc2878da946253a7318a2c9234de700a944126a6eb5c703883bedd6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f20af0062d0bc060e613efd577c8240e2fdae9a5e2b05a058e294e0bb4a5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd593b60696bcd0e7d05902849bbe600aa7c7978962979d0029537ce7efa4aec"
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