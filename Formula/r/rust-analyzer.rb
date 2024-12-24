class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-12-23",
       revision: "fa4a40bbe867ed54f5a7c905b591fd7d60ba35eb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a66e37ec7b617744a7fb011baae6a16f9df095864462d5f3962beabb3c7c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c26c9b50baa2b110a47a6e941a60453262736219405d52faf7fdd769a9f97fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7f3b0f29c109aa727d47bc3be35ec14d2237c5edf97c5b28cfece4d505af23c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddf5fb8e4e54c4ab55897432972d81dd689473a5278557d1895d9f8941f016fe"
    sha256 cellar: :any_skip_relocation, ventura:       "61d129c82c6754ab4267db0e39c03887d847d77c1a98c5e2b590fa654340f1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e266b00b05334f6d52808f9dab44413f53bc998e3b057986a0d75aa9a1cec1ae"
  end

  depends_on "rust" => :build

  def install
    cd "cratesrust-analyzer" do
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
          "rootUri": "file:devnull",
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

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end