class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "ae213ee0085c61dfc3ea25737e7bd26b4d0a2b127f662e0c516dc6f57b158397"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa391b9ae82bf418c6642d62f1fe8741ae54e6129426e3dc5ec27f6ea625b005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f73c0bccdd80f981803ffe68ebe4a8d0ad7ce35e54deee3df7518a808fe3afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59cf9c5b98065cb041277c7a883652b2c7b40f7245991cc47bcf6b7af44fce50"
    sha256 cellar: :any_skip_relocation, sonoma:        "d079a462345070c1cf90c570282f9aa4fa44c74327bb50dae48c0739adaf2d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847d5778b218b008fbb78f00c5dff4fc530538def62e62c990ef2468b6206de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf4c560fff299913f2f6c7700a36bb2e8c594927c133901b98bfbef0ef8f3c5"
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