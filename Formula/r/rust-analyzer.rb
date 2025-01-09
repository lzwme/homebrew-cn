class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-08",
       revision: "238ccb628bd4a9833fc4645b000ac585bcccf582"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c46cf0aa7aaa69f116205e2db5e34364da8565b48598d27b36be6db7b5e360c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3549fb25e31fcf8b5a143d84403c0cec1c1c7ab840ce89190c2ca60d1496cacc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb4e32fd93fabed3969b8207f24c78f1b4e3d0b3b7eeca48b12f9e8e1197d256"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7ebd6ef91307ccb74e4bcaaac36cbd5eb188b2bd03fa35577fc0ef9c15dfd6b"
    sha256 cellar: :any_skip_relocation, ventura:       "af281bb4dc4d3604c2f33af28a9c6974981cf46eccab0990e0eabad4205eae8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8b1253764d6be991fa25ebd397256290f94e9e74c68376c2daad97c205c2eec"
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