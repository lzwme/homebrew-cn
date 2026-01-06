class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.23.tar.gz"
  sha256 "82ef16226004e38f154dac56da810b0162f408fefd66ce79bb8a260347674e83"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5daa0ba6a1305a7fc9739e1550958ced9641dcf41899a66a1cee2b0f4c78e052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2291a56b982289477f07290105d8593b7e57288c7068052640c9a7b119acc006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e3208fbc4d979b11be9e064839b2c1dd5a723a4cbf2dcbe5fd38a1f0a7b37a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9500879c0c378b97a7804a15d5b4bbe16bbf7dfaef2eedc6908bea21f7c0c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d312ed041cbb0a5b57c03b63d6422f7943e241253723efb92875029bdffee5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c5f6c8009ba7c7c1d98ebacc6683880ee7a62a4524259b20e50bcc6dc6d4108"
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