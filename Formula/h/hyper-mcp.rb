class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "35f3c528f09b697f876e6fb451f6b3f9dfe0d4fec1912bfcf02bb56b6bd82cf9"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a8d0aa1275a138be5e7d2ee69cb76d4683c3252b9afd5415c20f1a76b17391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "390abef3bbe2d417aba05ff0461e836b6072d8e23514253acd4887dedb2e943a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd236c277642bc23539c0b9af2e0f84bc2e537bfa5f29b74bd9cebe6a6e7e8ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a19c0ec441a60fa1cff720b25caed485d024f45e3446a1673b2b65f6f2097cc8"
    sha256 cellar: :any,                 arm64_linux:   "22ec10d5b2bbdf4469bdba2d083604af7195e65e687d57375f7994487a75d0f5"
    sha256 cellar: :any,                 x86_64_linux:  "e66cf73435bec036b6c15cf8b2acff7792d7bd2640e3ceedea20ae28b2b44f5d"
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