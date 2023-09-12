class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-09-11",
       revision: "326f37ef1f53575fd38e768065b6bcfcebdce462"
  version "2023-09-11"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d620348ed8b2817c41023b769087c61316a32a299a37dc3886f12287b5d161a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964fea7ff9f143503bab99bd4d74800d82f55301799ec9bfd008ecc846177363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07fadcbc6d6432ebe47403d582ef120b4251480f3160d4e8c8a6775289eb791f"
    sha256 cellar: :any_skip_relocation, ventura:        "19ee47ce677e453ae13fb7145bf0695fda73fe3252e95b03543e81d3179cca25"
    sha256 cellar: :any_skip_relocation, monterey:       "cb74abed44ad6249efeec4dcbe1aeedce1d8866f1cef9283a8ba67cd3300d66f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c76547cf39592ebd10893417623dcf0dbb8d806833093521b3bd82a662fa2664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a290ddcbaedc4d79a16667d4c74b8d48b63e24fc055a57900162ce16d5ce790a"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end