class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-08-28",
       revision: "144526c90840e84e799ee06c6cea5c573cf4fdf2"
  version "2023-08-28"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7351d90a76c103b3ab44476274ab803e3157654ca1a313bf9376a77d63a45389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a506a7240f4a66932017406cb61ed08cce5285df03ada397ee4bb7009b129dab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64814f1d6287419ec5befa2fa762f39c6b9fca36fabc80250374d2da6dfc9b00"
    sha256 cellar: :any_skip_relocation, ventura:        "e9cfc64e06a3b0b40c543fc9ce7f736abf25133fe2018780f052df40bc3c343d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c24d224e187ce9a765a73939349b037aacdbb56f7265d855118eba7743da4c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4512be64646a8ab2839370bbc5f9ce194b980de991e7243dd98fb75bfa44635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb541aab487d57aae80320617e0b274810fc3a605b651486c8d01eda7c23bec"
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