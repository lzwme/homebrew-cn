class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-11-04",
       revision: "a341d598dc55f8c3077394df84ec8c14a502a787"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6dc7586f08d109989700ec7a07cf30856a1f2c17a4f68c50fc91d91fcd2608f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af6b6eafe0fd176d486d8335f4885ffcd44452f7437a26238756bf2acd9dde7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4696e59d4fb2588b001461e9d027f14c531abf02792b192fbf9ce865b55702e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c815d0d74c63e092ec78e252ef2406279d6d1eff7dfe70392f9e45d935fe4d3"
    sha256 cellar: :any_skip_relocation, ventura:       "5fe2dca023f578d499e4b446fe901d4f74b38c42201cbd25f06d453eaba31c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58cd301ffd0802b281bc71c2ef731c725b32a029128f0ed3c9d8f4d367e8cbf3"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:devnull",
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

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end