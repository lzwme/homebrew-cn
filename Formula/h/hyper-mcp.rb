class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "8502e4c4e2f8409250b43db0065b99283c1156d085da3d8a5ec2a489c6207a49"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07c80440c2d51749dfdf81e43965f68706465580765d6ac10d86c91ad70447a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d22e4eb49abea31201775c347920c21cea72708ceebbbe03c7fd9b767d49e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffeeb295e7f9a185759a9ad1bcfaddd1c360bf44405780f38e861b41d10d028"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7067861dfb358f157cb4ee193f27bbd68972a6e482a84894ea585b633682423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0543b8ac101b1c0c1ea19594677205e30b4f70bd4d448bda131694cf470ab771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33a24db63e835142b384cf9a053cf249597988a81606391a1fc2a8f62f52275"
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