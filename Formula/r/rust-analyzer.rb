class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-03-17",
       revision: "b0632f749e6abf0f82f71755d7eaca4884c1a808"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6125e569e6f461668ecacc9a9bcaeec798e4e15d382c103f3bc206fc2e34afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b3f9fafabf496800ca8ae0347cbef8b3d8aec7cef00d242ca6055668eb386d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b99d3898df6764892d9f81748cf490b144dddcffd42741b707d9b8680cf4e1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "68286fc369018e85b33f641c24e4806a4b384052fe9888a4443f65dfa4ffa10d"
    sha256 cellar: :any_skip_relocation, ventura:       "ac958c91c098a1fe2e003d3adb44abc2bf6d4b9dd4e1994fb899f59f13c8ca08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd4706fcaabce2b0403b084113fb73e4729b6ab125367211c997f969b8cb26a"
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