class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-03-10",
       revision: "5e7dd31c80d5821113ed9c9aa1616a73a63b49a1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b968399d2b1232060bba46ced2ba59e090061aebaf4842e0dc4d1e7d3a9e2212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f95573db777ca023a773b361a23255c2e6927c696856d738ed2e6892474d84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15251d6fae91a6bd8d604d9d3e4fdca1c389818f533fc97fd8d594c901611968"
    sha256 cellar: :any_skip_relocation, sonoma:        "9318b0592714c4e99ae088caec2864778e1cb3d2f0687eb0b58af72b1b2f5ca8"
    sha256 cellar: :any_skip_relocation, ventura:       "a3cb8f5c0f763ec61f942553c1d96300303b04fb43b82ef34a2f866dad072336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd5a71909b35531af762f240027889491386e428246172da7b67e6960ce985f"
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