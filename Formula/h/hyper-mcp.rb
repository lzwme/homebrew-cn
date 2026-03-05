class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "b5feadaeaff294cf3dfe5dd2c35f1ad2aaf65204114fb6af23c1696a09e321d2"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "627b89b734c6709ee17773ec84eb754e838f09b92ff3da54903efa33292992b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22888e20daf54e2362317765def59ac2840c380c2c2dfe9ac50719a6b266f5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3d91591c5fd17c2a7fe28f3d8168ee6cca102939dd49928258f525c7f248a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f147c84a6d34a5c0abe146562c5e404118ca4b92dd7ea126133ae599f0f22efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "823e4d44f180d8c2578ecf8c873f6bf51bbd6e984fc0d24e70b0203ffec63821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc4d0335811967e0bd2af8578c30c700980daf2e290d5d161f7f001a1977c29"
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