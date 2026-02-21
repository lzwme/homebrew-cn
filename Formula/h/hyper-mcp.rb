class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "0a33285dca24f27a27b117fede4a4653a865347171a8aa897c3704e63876ed14"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d923c7e41d79b7d9b2d5b828cb1363a17206eba21b2852eff8631be2610ea23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf21d63c5e78c8ddce3883dcb0bbfd3e70ecb9038fc4f87db74b84fcbf77595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eccb655a7043221ef8c4fa62b06db8c9dd9da25373f0eeb555209d356609a3a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c4e75ca2939f726eb434cbe96596083593587328183c9cb298613229ac63aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8319ba1c40ab00a0fa45fa43226cb733f7e32902cd3530b4252ad6f0986c6c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746168ce3159b85b539fb64b514a597c0f4f2f87942cf5959a2c93b601b6a435"
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