class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-06-09",
      revision: "9fc1b9076cf49c7f54497df9cfa4485a63f14d3e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55c17c250d691a4ffe1d3ab6191472432d7df7c25872384404af613f1ce5d463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0573f34e3d7c10c2023f6feea5fdf434b5cbba39f5c06481e3814ed2d8c9e8bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c725fa4f839352043b5b66405cba8a18da43e96e6171e0f878081ca6fb7b838"
    sha256 cellar: :any_skip_relocation, sonoma:        "437398b2010a5c6adad2fd4affde089ff6468d8fe82c700d44fb956c522c3c29"
    sha256 cellar: :any_skip_relocation, ventura:       "4c411a283852c64d4866d376f9a3d90baa39a024c3306577dfaa452d7a342c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7bbf4f86c671ade250f65a24e6ccd108304cc739caf728ff9e313a2f39710a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8130c7d1cf267cf748217e4e45fd161c99ea53216f0158802165fc81f68bd90c"
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