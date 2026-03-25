class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "cf933c42a4043037ed4f74f7e807ebdb190687365f84d0879cef72b1af74559f"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9e78e983f579bbd69a2984eddc8d2f84f13945bc0b0ce652b06e10427d12e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8cafde4e80538ec38a4719ba0195ebb31d508b3e4111cecf78a31ab2e1bad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d860d8a6809444ca73282d510126e3b1bdc7a231a06d216418a217d5130e79e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "df43707f5c0cacf1671f16829c087874b541f8f69a6a1824628e6b0f170c7c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ccd63bdd878a17f9b7c46b39680a48e344930c5d91a56f3954d306fc5e64c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2691c552431a0a01b369b9d77fb5285a01253124eaee42b32acf1b81108ef305"
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