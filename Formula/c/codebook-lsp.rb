class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "fc1fec99d032d8cb0e6d04f03989e5a90178e969e4ea2de7bc2a7c42f9621fbb"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb388b6ff9306f83b895d1e2f17cf58de250072b7167e4d98962ff63dbe744a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b617d607f2d9d6dc8355c9b2f19d1707cb0575f9567ad91f51a32e78d06ae69b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "186f81203273b4a12581bcb3c89759e56d2af760ad51f4b44873c8acf77082ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "118d8db766d1c1b5390821195485e57ca458ef83d51a6aaccf23e8d600e7dd23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de66e8cef526ad2181877faddfcb530c585fc17506298f62596c3343e420a862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963d9d14d8eb19b8deb8d371fa5c021b10e75f6ff7011acd212af747df8b0e16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end