class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://ghfast.top/https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "94a8d2e20dbf33280f838e2702436648635d4d83b1e8c58b98d05eef20594549"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040ca491ec55637de9ac9a4ea00e3e524683ea894039994e864757087d076f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5e4517dcad4769194241f5744940ba1febb31e1c6d52a7979293a04aa9d0c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2f6f204488fead18179ae12468b78f4e7e54b0af4a43e8b5f3b9cee563c0462"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed012c8cc4afa30d70b6e9e80189853d9db4d88782e3babce98eb7d0109b3b37"
    sha256 cellar: :any_skip_relocation, ventura:       "31a748a9bd42648f3efb6656007a3e65e6a6ddd22cd3758b6ee510112a062ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0efe13254b6d43742b6e0df12a06937fc24cdb94d60ea5b3aa787c134d127ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba0afea3b8bf83a1ddf3566a79ece47778110a6dd9586d2e58c89ec21da703b"
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