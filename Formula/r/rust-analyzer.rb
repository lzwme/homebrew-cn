class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-08-12",
       revision: "0daeb5c0b05cfdf2101b0f078c27539099bf38e6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7229856010463a638202792412114bb382e9219253bb19408e631609dbb461d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2541f4e095bd8c2e46438887ecbe4b310563f59decc4bb860ffeb63948df67a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372b14ee26c01b38b89b03b21dc25d5b28c3aaf80dcda6bc484e9891dd16a541"
    sha256 cellar: :any_skip_relocation, sonoma:         "74e5dca2f66a4370c32d71f6b3bc1ad1033d615d46a22cd41d03d45a6ce8d593"
    sha256 cellar: :any_skip_relocation, ventura:        "885e650daa67f76539ba3199f8ceb07cbd4884efd369eb1edba96ccada860533"
    sha256 cellar: :any_skip_relocation, monterey:       "699eec9d71fcc740b8962ca6ba90a66e2aa9069ccbc13afe685db193215ccb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805d2571a46b75e2dcea2baf24122ba2e86fbf145a2df0c1f7f69bfc53e77c3b"
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