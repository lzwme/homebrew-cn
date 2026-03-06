class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "6787effb2a7573cb134748cd30831c56e335b455701f3e6d045510ceaec0bf2b"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d051f8f0e23b3e86dcb9f49ab97c13f282ceccdb4b4d624df8c7562e184c3e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2eec8d9233d9c0e269d66cd3b9ecfb8fd28c490b888acb8faaffc38087effa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef1babfde6c69c6920a5705b4ee1c66125c1634334703c490227737e2e93859"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28061d683434589f0eebf83a05a588f41b3d69f3d2e99f5d9e083a82e468b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba49a101ff319ea08dde1871c206b63e8387226d95382fb46dc96a05cda93035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d56652cfa1de26c17638f2045ab146a6490b297902949f2c7741e4d005c0d1"
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