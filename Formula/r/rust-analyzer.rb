class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-06-01",
      revision: "c5d30e2331acb2cec913a086ab242591f4f367a5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab2b28b44b3c002fd27ac950736bd7caad10eea3ab4dfea0e4af3fe1bcd13e12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f198fb09aa4492c8496cb093118ac227209280bbea5713598379ed4a6a434b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1306706136eb36d1bd6bd7719a68037021af144935f5ad827e9712107e896f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "c086f5c6cddd088ef5ebc45381cc58b36b182412de5c4fe177560654967aaaec"
    sha256 cellar: :any,                 arm64_linux:   "90897ac7b484c4783bec1530a0b2a46ed11d4d7836f8f628164d871c57c5b56b"
    sha256 cellar: :any,                 x86_64_linux:  "c2ad71158ed86c0a9f7cfad47b658f6e9820caf9cc5ec0917f004d9acc23e6eb"
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