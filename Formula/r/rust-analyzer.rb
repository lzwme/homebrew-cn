class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-11-24",
      revision: "4a2b38f49f2c15f4302502027b6ac09914679a8f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "058d5f41821fbc08b5072c550c0e355dc72fc33dadb1592ceb5fd5c2830a8772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce6e13b2bf485e0c0a5a4dff1d5fa7239228c20ac07c84d5063c71bf9887899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d37e90a418dfa97eeb412a993090bfe9bb2704083cc506c6ffda2cf86b075f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fb141825be8a9a804562bf3f8783ba371da25858c575772a9678e4e48b14f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad0727c7e08fcb2762f12fd72405af7f2f9f8d72ecf12a1b191c8b7d4cd8645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d84373127727f5b58d0f04468120648194ae45d9668dff5323dff62994561e"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end