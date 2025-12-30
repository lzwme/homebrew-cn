class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-12-29",
      revision: "be6975f8f90d33a3b205265a0a858ee29fabae13"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b995af817fa11b32a415f9658376a97510d58db5b055498850c8f431678353f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368328ad328b36ce1a3ca907fa0e401e5a0af6a3f08c3730e80d62876f878251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb50bb605691dd762ea1bb430d12b8abdaabb2fc7dd14244b44d4ea949cb0397"
    sha256 cellar: :any_skip_relocation, sonoma:        "f831a5be1fa592d6a6188a021eedabf363a13e4c3b4a668028a9ac48b4888be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2bb58b1077726d7fe75083bb8818d5c1cfc72dbb14bb4b1555012b7a56671e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317ed9b3932dc9a105128a6828a9f37fd8ff4a1745e1780998df12c0fc9876dc"
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