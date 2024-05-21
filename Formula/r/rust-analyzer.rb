class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-05-20",
       revision: "21ec8f523812b88418b2bfc64240c62b3dd967bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "474f3039643e8a1b6ccfd7650affa08897c330219aadad4c5545f68263ff2447"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0795a636e1af11989f44c853eef6b4f9818e066b07ff84a906c0b1e7fe14e62d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334c50a75bb0876cb8c17aab1a17b9191f476c7f40d7f139ac311e76b6d4c47e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a0de2ee39a169f9ee49174dfba287ba0f059ac45efad47b50ee6e18fc13e5a1"
    sha256 cellar: :any_skip_relocation, ventura:        "d0a94b35c0a1685560e29384abaecf7d5a7b40234c6241c449ffca722046e581"
    sha256 cellar: :any_skip_relocation, monterey:       "8b603daff779bc705b0e93e74ed128c8304510d0389e0918f6c54d3ffde800d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452f4f537ba095d6021dd6a838e2d113f84b8b4f75768aff1d9235127ef6ebfa"
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