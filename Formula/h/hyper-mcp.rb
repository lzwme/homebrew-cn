class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2006f69c007d2d69ed956c730f51a6a67620fc18dce880b4464cc1e46155ce49"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "973dbbfec6fc9d82fbe8f6ca18331e57556326c32d91b3b4f222136c5af1d803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a008bbf4dacaa873ac308b8a29d03a62b9689ab8925b63c87010ca562953ef85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c165100a489e7909550f7a8c6edf5144ff3831a5eda9c590c641f4fcec798c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "279e21e1656d59c8a088f73a9617889d22cf1383471de1806754c04b0b5a22ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca2bb41b2f460a00ea0325972f147f4670d0ee49d5102a715297e75acafd949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7eb339416000f3003df5d38b1229428f60d1301c2fdf91e7052a5293ef3365"
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