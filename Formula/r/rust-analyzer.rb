class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-02-09",
      revision: "c75729db6845c73605115b18d819917dbf6a8972"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40739d095900d479be798d23c06aff3718a9aea7279a3e3b130c9612a03a842d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20421c3d97629657a3460f241157b3a03cb08086fce45be6a21f5bf1da3d9c41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ec043f682caf8ff50b7a71a67a05af28485a20c551d126a3210161b76b1caf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ffbaf4c07edb14992e131cfcd35cc012774a473f529f6af173a90e9f5ee347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83b5d63701262ec34e5eae09b837eebf452a664125ba92041785f2d283e20967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c754ec97650d17f0fdeda4de9ee5d95cdc4ac912cd544efcea371b6b8e792f5e"
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