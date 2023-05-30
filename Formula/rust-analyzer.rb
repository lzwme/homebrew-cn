class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-05-29",
       revision: "505fd09f9e020b096d014e68b667268e743c2dd6"
  version "2023-05-29"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5550a95f493004e057bc6095cb80af8f0a0bfd2503a903af156324403a30695f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278edf0797517414a2f953ef6795bb1c119c89ec1e05f434320900ed7d7c7e21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61f528ebdb8e07ba216d85808d7ec5cc97cb970bc83842d8ce7e55c9b5a341b3"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9e1c0fff90f36ad749562e2492f9ed199eb600e008f3a4d7b0715fdf29001d"
    sha256 cellar: :any_skip_relocation, monterey:       "7aca4670021a0b0e00405e1a5e21605d3d170c6e758c9500a6f0f152cafc99fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f44963e0424fc448768fdd4ea0fcd5136de851bbb667c6d93a98037b1b470e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb949bc0d4a0d4a51071664060c6d863eb92f845d6110e6035cd158f4bd8488f"
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