class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-03-27",
       revision: "b99d5eb97315faca04a33bae40bd2fb809ba9d46"
  version "2023-03-27"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763edd4eff712d931ff92548df16f38b2f954b46687fbf697503c8abf474fbef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450a72be8481256a2531ac92e60ce5da76585b135416b67c322c8036eae0d2b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac7cbff9e1cf615bd3b83da66ce76a74d7c8ff11a67a3f9bc7fd3a147c6b7805"
    sha256 cellar: :any_skip_relocation, ventura:        "3094350a5157a8b43fdc80892a36b9a32fca1e8574cba18354b34568678d7036"
    sha256 cellar: :any_skip_relocation, monterey:       "ff157de24702d2182c01f206403561a8c3c78fe15630c8f7a661000ab05bb976"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cfe2d98296e94e9dd02934ad213bb9d1ec6f177d2b628f29a5e3b25f4aec14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4880e643115d49d7470d5b85ce2cd37fe0131b88fd92244abeb85b455a68d81c"
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