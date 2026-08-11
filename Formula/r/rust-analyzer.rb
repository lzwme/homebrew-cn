class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-10.1",
      revision: "f938641be53c2e4bacd7dc46bddb74825a3e9d28"
  version "2026-08-10.1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a608c49a7b5e680f16b95d92e83aa8cd7e66f96500d9ed976cc2facf691152f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16020ba30846fcd70d21da0ab3e38b0dd293feff842724e6d223a37dd85c39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e23b8d417034a809ebb5da275345cb0db153a70c9366edd03ffc34bf0ec5ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5faa4949220db8f49dc4a953e6de42b78de1aba2cb148cfc8c718182c0bdb6c0"
    sha256 cellar: :any,                 arm64_linux:   "0030104067ecf97b166720fc10991a5ccfd5fec5bd0187e540fcb9637d82870d"
    sha256 cellar: :any,                 x86_64_linux:  "61d961ca492d13ca23f49f64429c4e5e09940a162f2efcba5b3cdfa83e56a9f6"
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