class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "9f3ef388c48bf63150cd2a78a40d534eafe4969f49bc36a48ec758e1c51b9d27"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb1e7ea1a98e7fbf602606c3ea5b0d48a2fd4466169ee6f4c73350d517c8e02b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ece411a634272d69dff23200f1ff2f229017ec3bede7e51f2c987f74242f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96e7616a806a0882b6580b89183c696e1b48e52de6d968504c612a09c5fe43c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "887c595d3bc89c4bcbd58d19d619cc5a7320e43657683f064707b4f74c86d2d4"
    sha256 cellar: :any,                 arm64_linux:   "d2470713e93b086e46d998f9c2853852394bfd28e77910e9441f2ee13418af28"
    sha256 cellar: :any,                 x86_64_linux:  "ed2edda4b608948b025bb1c992a92667ed18e67938c4b5674778f777b4fe7ae7"
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