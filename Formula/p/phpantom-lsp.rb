class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://ghfast.top/https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/0.11.0.tar.gz"
  sha256 "af15e4f73b510f6d00bf2ce1a01e6d1610c15c18547f8bd987c64be571782475"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6b16232facd1af880b3c5cf483089cfb15ccc66a86a8b8dc0ce24c164295a10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f322ab1b5093f5b0c9361353e741e248b5760d4727d41e49453feb2fb7cba85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ff5046d79c915f494af44ab93281831367539eb542a878dc1e134161e7b9355"
    sha256 cellar: :any,                 arm64_linux:       "353668968f362af2f6fcda5c8c0ff61650456eae42984125f5895c8cca84e7ab"
    sha256 cellar: :any,                 x86_64_linux:      "3f60eda4ee22c222be81d08e236a90b21455c84cdc5b2393363fcdad6799ac9b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
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
    output = pipe_output("#{bin}/phpantom_lsp --stdio 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end