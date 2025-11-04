class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-11-03",
      revision: "bacc5bbd3020b8265e472ff98000ef477ff86e4a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4746f4abf678294e16f13806237491848e5a231b5272880ee6da1fbbaceaeb8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b69ac43290d04a52a27033267ec8e165952bf25812df0836773c6b8cb47bbfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526fa171b0c69ed0eab8cc46131d408c7167a9763873306a802ec613899d7ed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe96f6a30ab28bb481614ae15dc23eb51982f53212d7325743fa222771ccb750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac50762ee5c0cbea7e4ea61309d1b5cbe7615f2127c3d894cadea5c2bc28584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bea640e2b416c6155ac3c4c3667468b96aa8f259cc8148c314d65e5b095225"
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