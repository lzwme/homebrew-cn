class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "0f642c1d8de190193eaea4a77e70367d50e49effca7b6688164dd1796600a935"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64129590b914113723a884ffdd56b3486966b7c67d4295a09ed737c029673ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55bf8448b42c9ca3a52766470699a5fc31290d0a29ce64dbf4807c1c1fc353d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d97a1837d8819307eb62fcc031c30ccc43f53ddbd7d72adf0c250ecbdd6050"
    sha256 cellar: :any_skip_relocation, sonoma:        "011deea1d4c2e32bc182d2d881739cd53b441838c2de1c2a76128b8fc4c56e17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88eacd07dd16b46d487a2fb55b2da2d88b942986422b84e2d68d20880f234095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6849ad3c70d599532f77713e3bfbb0705686da7c1ea2c58e33fe16138dd716"
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