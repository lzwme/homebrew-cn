class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "de271bf2a9239ba2aba9dc9d026e9ecfae005001bfec9b428dc121194ef6dfd9"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e21f813748b6b08cec1a408f548a9e4e62571b6fd1c1590c5a01b1d6b420344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85e1443f9fc8220a3604a192baa0cdb51be5bf7a9750e63c34267087fb8317ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5c526a1ffc62bcfa792c44f7ac03c4d64b7dea5ec1c6108ac06813ebd31018"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d1eed80368c261161f19a37746216dd71378ce9c9d14667f957713cdac19a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9344b04c31adfba88a73c1d8ecebd8704fc1c02708332d53b720a1bb22540ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43beafd8dd96be1592ea20c4a218428fdc2a9495846cbff9cdb7d686fdc927bb"
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