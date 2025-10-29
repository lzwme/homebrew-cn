class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-10-28",
      revision: "7c810e9994eff5b2b7a78ab0a656948c1e8dbf18"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c526352269bc8dc09e0d1548951203c4d9faf4310eff85ed139ad1f4bf74c58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa739f20e5e56ed5b728901fd30a7e138f6273d2062dfbb5dc11e12a373448f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd41f7031b82981958b16fce8251effc1ef3fca48f8cdc5273d700f043e2afca"
    sha256 cellar: :any_skip_relocation, sonoma:        "11abb6218353a2dd4b8a81a21da87ff662e6a2e791659a35717c90aadc915b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3146be2eaa5864761934dcceb521a51d7f03f1c9ea2c0ad0d227c9fdbd694834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f7ff89183be44d595ea5ca8b9f39a02d15abcb084255f2d579d07a7ddb48fc2"
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