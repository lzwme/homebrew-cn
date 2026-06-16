class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-06-15",
      revision: "cc272809a173c2c11d0e479d639c811c1eacf049"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3964a95fc320095dce63aeebf3be0f8b7a5130f056aa6a82a4c8d7fe88b79d87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bd7d4fcd98567182cf1e60a9c7a5747e602e3fbc0e3fa255bb63382c8d34a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5f4d7e709a7ef25dcd9ee0cb38255805a497c4b2981f39b1dd4314c94f2b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "05814591ae6968a390bcfbffd11c5b4a799d63eec45a9d6c4e4febccffbefc35"
    sha256 cellar: :any,                 arm64_linux:   "47bed0b11719811d47ed4c4e8c99caaf5f9c92d531b16117e8df520c93a7a429"
    sha256 cellar: :any,                 x86_64_linux:  "d3d7dc89f0bcf29c230bba6fb546fd0fc16b001d6a808aa264ac20410fa111ce"
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