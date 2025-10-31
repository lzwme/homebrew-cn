class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "e8ff980e3d3e0cbcfa132d2de28bd0a2720ad9cf6d17b8369c6d7b9c1fbe61a8"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53976323dec7978ab02caeb4d92aa5e52035d0fb818ed45ce16219698ccc24c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c7658cdc860115d5701b66bc1419fd21a141b2f3a66283231bc3d1b741be31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f07bf22f209fb4b947c005d8b9ee76471b3e09277c0eed607d24e018840a27"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb76e26f79d2b69d274a7a25f3fa724fc8c57785734f80678514e549afba879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ffe8540b216c0bc43d208846496d8bb08f6ab14ab8ec3d10fde4c780fc7854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3526d95440920c554eb7a92d3ad9c93ade729fb481e8be4087a301650b58c7de"
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