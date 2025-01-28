class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-27",
       revision: "2df4ecfc74bbadf1281e13d73f8424f7b5c1514b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1046e1e919c40847401707fb2cfa89a5ad3fff93694761056dc6e953224b28f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45b67f87bf035ef662a4447ab9c3004e8274113c33a696cc99c0c5f0f51e683"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa5531238709354e28b901c2e61228d37fe7348ef43e4711499f78beef6e33bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6edaa2a32029abd6b01d4fd79a4bdd11823b39825dfee6a3303b9a280a3fa054"
    sha256 cellar: :any_skip_relocation, ventura:       "0965091749e1378f12e226a14003ad0ad83acb2d165afd5fa3bdd7766eb40122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681fcf47d69bd797e8486e17a4441d6ea19eec49ed6c085e245c6e6ff099bfd1"
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