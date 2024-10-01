class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-09-30",
       revision: "822644d97d7f64e1bdff25b1d636e366a29facc4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0f8e8a89912fd00505856ade844c3c8005ff94adb1777071e4073620cecf3d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "085487c6b63a47d8642b52bd80d64642b7e35b21cf2acdf8b3e88cb68de582a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a73799f70d10b13e84e034cc40bdafcae525013f8839feb3b566837707fae4d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f3e6e8d102db1dac8a0323bb5f0951066d4e9f345277ae100cbe1f29c61255"
    sha256 cellar: :any_skip_relocation, ventura:       "252a2c299bb51b32d20011d7056532572c0bd25b5e9ce8e0ddd81b1a0cad824e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab10d132c5a6233bba89e5a588ab6c33fb60d39819e74db408ae043723bbfdd"
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