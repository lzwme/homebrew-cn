class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-03",
      revision: "b54a82b321c9617c5cf0b07ac0f12c08f7bc5902"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1797034f7b111b6ced70674aab7a5901e373241efa45764fd434d2c022e10eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291d2e76133db6c2853023ef5eb26bc823cfaa70367edfde41f8e6a4231c117c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10ac52258b0954f1d83f4445396b131a3103f1682eb84db67a1b5b4a0bd579a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7b925e8afd2f35f38c8a1060dbdd58f1c5b83e7f01c9962cd9153a4a5f0cde"
    sha256 cellar: :any,                 arm64_linux:   "2cad2ddb85b121684033de275985f8ae2f6965e4dbeefc231af23278ab9c7f46"
    sha256 cellar: :any,                 x86_64_linux:  "7ffcd2e33b54a34f3a98d13cf943382c0f2935a9b2ae20041c34d18ed64508f5"
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