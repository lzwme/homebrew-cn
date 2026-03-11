class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://ghfast.top/https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "ebd2d4b4737fffdce87ad2bdd57717569ed580cbc416beb6ca8eae8f7cb5f995"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a15b83411aae2e1cbfe40b7351b90f9828e58ad6bf5bda2202ba1e26619d55ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e952cca1612ca8d62de1f7625c5c3b951ef2ee6727f53fa498534479f4cec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247fd0fce416da727f9f44c7cf32b899ff768cefe5d4ed46aa3eb942af0d356e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc8b40d66cfae1dc0100c28e41d05344481e2ec784f093a70116f14a3ca39b90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ed8f8278f5286afaeb64929b49a65c3cec48049c189b59c359ace17370516f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56eae6f6450c7cb571fc51cc5091f11e7baf568bb9cbd2492b2e9a962b844d24"
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