class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-03-02",
      revision: "566fe415d158452c72feb026f43e8d81e249ccb0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbb86cc23fd39f7fdd1cd6b5a43bd93be6bca796a87f67d1993a8e23b60cc7b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a2e142d2eeaaf78583803589fa23479886f178a0086e98f8019c8f3f0c70fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c6f08023b420e5e33ae91548a190a4efd7539a67f8d59549a0acd62d28fc379"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d4991fb86c799cdd58eec643ef0fb9b93515a40067d227b4f2047a85785131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb1ff93503104f1b0d688586e3baf03973fdb98b432fd1b6d5f838fa3c10c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267047d1a79f02e1d37db9b5e0030f9053887187ff74c586cdf87b78667126f4"
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