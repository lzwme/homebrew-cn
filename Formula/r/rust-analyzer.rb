class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2023-12-18",
       revision: "21b06c1beb9bb59369ffd652f5d617bcf6952e05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "743aef06faff176807e524cb8ec1cbd65f5812268dfcf9334d36159a206f970d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e76e21233fc434607dbfc6b4c37df0dcec0a7ff416014cf6a133ec410cb520f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b79ca015424905eaf94ad75c53e83c2d272b712df0ce973d102e152800086fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0903e0b8132497ec1a356eaa5cb29878a15ca16bf789f700612852b1d65f9307"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef06bfefa058f82ee7d816e511485d139d29dcf24d20ebeabc106d486d4fca9"
    sha256 cellar: :any_skip_relocation, monterey:       "23ca60c4135d4f00c8500eb1250f5f2de38ca93d034deacfde4b21c0cc20460b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb2ee4b0c9b66934ec9ff93fb3916b3af09b14aa70f519db8e98a13838b2a0d"
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