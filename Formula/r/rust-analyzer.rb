class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-03-30",
      revision: "f1297b21119565c626320c1ffc248965fffb2527"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a9e059a335dab3a0e8e4d15beab8943d06fa976e5aa9ad0b0e276e15993450f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1af4ab1a30cbd19ce2945127b93c805cd028885dcf32202235ceec9ec27d7299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05046eb65688d5f2cba162cbf34eb64134fa404270984345ece433af2603d8c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b978e26ed6572b7dca8527508d834b3adee39a9cb56f03620ef4f64a8f39bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e37a3939ae24a3014e59c63b888ce71c7e36026e9cd9b52a43b3ac0976f0ab9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda86aa9f1d4e95342f491f7152b50c0a06c8f526b95264be44fd5ba75e44952"
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