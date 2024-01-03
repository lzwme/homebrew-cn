class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-01-01",
       revision: "9db515503f11bda7812cdfb9c2839f70f4cb1fdd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b999aaaa38f3ad80443e4609047a4318a0e638a5905830dba53e2a183a858314"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b354723180102e9939d0a786559992aec0ed496c4443dbaf076afd3a8873b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "946182bbc230f9d1f44c7597de97973b654fcec5c6ca75846bc75b537263c40d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6cd37629624d2910024481caf996439fbe100a68c7405741f75e5423dde4183"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a611770b4f234b8a39e746db766b9c88281be355f0545a7a27c28e18303e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "973b9acdf1137e9416c1991a34358690b19895e89af0d97b1a5c84208c8e2bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f4395b6ad29132ae94830e0ad5eae2f2261260785115d047fc64d01dc9719c"
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