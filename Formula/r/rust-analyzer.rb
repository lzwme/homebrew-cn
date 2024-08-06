class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-08-05",
       revision: "c9109f23de57359df39db6fa36b5ca4c64b671e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d92efeb1317481faf394efbca912b743f2b877c4b2730e43712692130695423a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f504c6fd160008beb6a5f391601895885386fe3a049face206aead9abc01494e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "546a0dd0b4b5822d915acbecbfd8572b5548fd35ad484530392807d62d35885a"
    sha256 cellar: :any_skip_relocation, sonoma:         "69548f0738cdd62db75520a553a6e62c1d8d7e9f1f7c9f687fda66a8bddf58e2"
    sha256 cellar: :any_skip_relocation, ventura:        "f18dbda12bbfb15887f6c6198aaaa46b729d380cddeb9a370999c5971ecdf91d"
    sha256 cellar: :any_skip_relocation, monterey:       "a58997207c73e82157130c772b3c913d7fe0dc8bded916bfa247e59d2ae836ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78bfd13562c35a39b3afea19a2d8858fe4bf945e101059816e8ecf9aa21793f0"
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