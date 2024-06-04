class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-06-03",
       revision: "7852a4c775375f438c4ab13c760c69200d8099b4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b215117d64bea65c9154aa6c2ffcebbdf89bb9c7102aab7c923f4348c5614e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da5e140923f3e117b28c240cf2f19f3b1dc5465a992b69935619e02ad39e7b7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4de4482105f16b44565b8defcec1782bc145aa6d24f65f7ae58fd006416215"
    sha256 cellar: :any_skip_relocation, sonoma:         "61cc4bbb97fc02d5d75402cb1c8ceb8b6760991cea99620ef38b55cd8acddc95"
    sha256 cellar: :any_skip_relocation, ventura:        "ef26721b7ae2140c134f13b5b7b847ea7380773558d4cae205dc130f78653c96"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1f24a3755766a3c4ac73c4da710b082cd4b49c783fc7ca7019ef57a7a42a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52fbada925c7cdca018aae634330fc44dc00c9d8493b01ec60d2e859afd8fbd3"
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

    assert_match output, pipe_output("#{bin}rust-analyzer", input, 0)
  end
end