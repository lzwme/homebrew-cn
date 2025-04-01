class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-03-31",
       revision: "fb133c8c8064d9f18f19eae8721347872f1679e4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45667d5434463e6fb64dd24ca61fb55fc412cc29bf69f303e01d76beaffeb02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "795f33008809c0fb990831bd51916a27506d1e78ad77c4297b287cc437f17847"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edcc704047cf5352ae43ffe8603cae3b5c1e70fdd2769f55ff9291a94dc5ca55"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ed650a293b0943b051c22b956a799bc5e1f62d49f4d5446c35ad67c3897d5a"
    sha256 cellar: :any_skip_relocation, ventura:       "5d5d9c07e477a4c7b06b148f51c3f79dfec94067dcea75450c5b7ed5c08c861b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd3897a8b1a7ccf6b6693a6fe3cbe4d4a7e8c67b4d61d4cf4f2640f9ded34029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9276e2dc37be2ba809954f2a7183af93a40a323fea76d8718ef0d3dc03d0711b"
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