class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "29bc87410a3df6db6d2c0c21093bea5645fea919a68c5122b8b07367d95907a5"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a1d53b68eb02ea88e3ee603e540a98d104bf2686c14f7450dd13794af3dc66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "626d73a575606b42f4716bc6cde018f193b774a027a9f6c0369bc43f9af701ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af81e498b54f6cead818b31a822292cf2ac4b7dff7cee60b90f238f8b2e4405c"
    sha256 cellar: :any_skip_relocation, sonoma:        "833ee15a93a97d6cff3bbabde5733557c36b65236a059543f2b32b241cf2372e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08bdd54e06fae961e9f2c8fe7e30bf6201eafbf9448426c2c12f8b64a48bb51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8962864386c5703c272fde77fce4a17e803d843d6f99baa15e248dd0e41dbf8e"
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