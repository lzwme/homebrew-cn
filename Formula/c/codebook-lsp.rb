class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "dba57a2c3649f5535b3f37adb66427c8e3d85f3db028cd985137bdaec06a0ba2"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2bf9b42190532ce0b6395d8921d8bdcac2072a0c33b7cc7782e45823d4d81b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e416149273a814d7dd22fe6a560b34e465d28fff59be5b7a89bda0fcbbe83ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f538dc8fbe7460065418b4d3dd7d0e53727be13708a0b500d24c1b5e9496aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "818f4ee602cadfe51fb838281164b93a691c8bb4d7433f2052794ab56bb8ada9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303452e36cb5140a1717bb16498974b55eff3b066163d1bb8fb28c517afa1a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdce487668cc7f10843f204dc8ae7c4dfaf3799f41b95948a76f3db4f3c64c8a"
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