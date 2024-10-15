class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-10-14",
       revision: "d7628c0a8b95cadefe89d9a45f9be5ee4898c6b1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cff9fdf73e8ec1337ef82797df0019ec828fe7381ebc54f5b83f37a02042060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aef02407aa72789417e29f1ab6a5b32952cbe83a353131c21ca8809a15d5239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c5d1eff7e232b184336cd5ae716ff455b403c4842c63ba30f15b1c0960e857"
    sha256 cellar: :any_skip_relocation, sonoma:        "250f55a1e761c3107dfbf25e721b9433beee84287ff23edd923486d5a3831622"
    sha256 cellar: :any_skip_relocation, ventura:       "0e3ef3d12c2dd20c0209bb96f9e0407e69357d761801a56daf68b9b46d5d2ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee2d015039f1ed2709fa7ebc6916cb67e9002f2cdd090ecfe63932ca2132974"
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