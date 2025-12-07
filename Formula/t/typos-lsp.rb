class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://ghfast.top/https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "3a1068e9bb6457e85b28ded1378a5500360f26f8921ae0033c0c49c13e71880d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a5430bd286df90f3141c004e7301604cd9838773f6839a785cded618cc216b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7fd885b7aa70195986410f6452fc8a7fb1d2f6b0c61d42b0467bb49cdd3f26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7060698a553cb63c57774446104e46e0570ee097aedfbc3af66801a8973ce4a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2826c004fabea9b1a4e751d83d1fde572e6c68a39b55d245c6adf0a2586dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4c24b9604f29a6b2e0db34c0ef464e77bdcbe5b8b4fa2aa00e1882d787072b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e158d9f64558b877adfef17da4749ad0e3bbf7b01ed894c3a146788ec25d5186"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end