class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-02-02",
      revision: "7cb789d98202b88c34e9710e53f8aeac0fa5096e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d05c4eda1ea5c2314e93060d5ccdebf6c7dd21a0c28a41db12fa922f02da3191"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bcc788cbb71603a44aa35cbbe02f70424653cb915aff4c58722e92b2139ef2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1cc443cc5a0af903925e36998126a7887e7b309c1e2b4b780b354a581b9cebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e7aa3c7aec3231b9b81672d80919b8c8bd07b635b6ca1f9bf571e6e9a07e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101506b95b1cd0eb5ee28bf6e045f81addc212693d546528ed95edd468b8665a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ccd8465fff4b26173db051492ef524d1ee14e0908ecf8dba7632dae6e8b857"
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