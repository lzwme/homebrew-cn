class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-10-30",
       revision: "f493207744da98b31295b02e6ed95b26a927056c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6914fbcc4e7b1fc2fd7941e1570e6ada3ee891e45d6fde4da758112dba2ebe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e9356d5734d8dadb0cc311564e8c2e6f28a0208b309b3d2f9cec2dba6a96829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d99a672fbc0d3b41c1f6702be87f4d8589e2eee8db837cc964bf8ab797f916"
    sha256 cellar: :any_skip_relocation, sonoma:         "120f536cbe197d3aed6dc9a344dfe350d93e8af04452b876c3cfa458d6187e3b"
    sha256 cellar: :any_skip_relocation, ventura:        "01791288926511cb83e7914fa68134a4b7233499595080d01f0534069fbb79d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9976706f12ac7f6388702d00e1a66fd101469471a46b2cc64af2b0ba4dc7b158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46a5573f3502556f5e113cc6ecfb3b1e71e431b92d14ab2c0a7ec2291493bcb"
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