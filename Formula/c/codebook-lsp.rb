class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://ghfast.top/https://github.com/blopker/codebook/archive/refs/tags/v0.3.40.tar.gz"
  sha256 "45a00a9d34ffd747f5757d1000b769c7b2f72d80ce229a02ff6de455d8ea2111"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf0afbaaa5c8586f00e92ed012359a99449c16bbb89a4b10c31c8dd78a174c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9fa83355d5d329f4d2c3a139cc7e73c101d0728a129f918910a0fe062588a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901cb2d2d4b297fbee642c6ed0a8eb9ec3813e6cf13e2f4e907c5dcf3d2ee210"
    sha256 cellar: :any_skip_relocation, sonoma:        "678257798fb312a431c6892bcd8ac22269d44e9ed52b95d046c20d4cc364926d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f01fcdb4be571553ab731602945d5d2cc5f1e6473fe73f26aa2ab6cbca8e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba011c763579cdedfcdfa840a0b8d1e75ff107c90d454e55b40c1eafc4ddb07"
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