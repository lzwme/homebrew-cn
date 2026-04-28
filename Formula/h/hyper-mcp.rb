class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "252f7f57cfbd1fdc924c998135ba457bb95dfcfdd0505f5481a5b3a188d5b78f"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c397a8eaf12ac23ff0f1fb08a0e260743b2901fbdc1b176a5b4a4ab35f75f8f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c59284613eb367609fa1baca554813d0f0fd96d3adba91a746630dc8e4b04b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73e4093962859e8e4c39c3e22aa5ca5f28af2b450b2a00aa0b4135ae0105ddd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "16445ac7519f2ec829f1181b280312a6d26f7b1e05327283e35d9bde7a9414be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe7613b4afc2317ae9bb6ea1e1ae6eae3f93e76fa584a2f22943b4ca9a81a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f241b32582f16d9a7c419bebdfac437d8c6acbf584f5ef3aa763ede6435091ff"
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