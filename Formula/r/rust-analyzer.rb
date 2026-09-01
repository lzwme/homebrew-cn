class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-31",
      revision: "f8996691e991a4dc3c6f135e0fc04fc5561e4e9a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9194b9dd37ab6a31b5d3e0b33e6ab768d1cf3503ded4b6547a5bc0c143c488b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85931b79aac0a0d11724750e4fbc99825106680c4f0fdfad996d71de940e15d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02d098cae830889276b97a29c86826f10b9af4443760f9437ad1e5759c8c8279"
    sha256 cellar: :any,                 arm64_linux:   "005d0826fb32d6c67cc73c392de67d9b932240ca46b5b2bbdb3b6e9a35f94090"
    sha256 cellar: :any,                 x86_64_linux:  "b0ca90cf91e16c324feb4e82a642675837fce680254083e41dbb4e86b3d6c73e"
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