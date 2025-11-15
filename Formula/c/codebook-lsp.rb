class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "fad96a092d1cd7febbed7a166d487be09b445f6f06333385e562b784ff5fc7f2"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500879cd2394283423fdb41a964528d8206a882ea310f5d39f87d9b5fe989fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70932b1318bd765266be3c60f4ed4b9104c5ffcd17d686d6152e0797f02835cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f423113664fc733bc94a2e540de2508ef00d8f2e88a840b39adaa33226c257"
    sha256 cellar: :any_skip_relocation, sonoma:        "f763ace705f22ece9f706dae485d7d10849e15011ee3dc2ec02eba3b6129dd05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e508c51fd6ac7ffdd676670b9ed90b17e5c775a91b807807458162787b3cf678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c815f2eb515c83059e99e4bb54a61464afffc0e3e816c7a64dd43ff77edd6491"
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