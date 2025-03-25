class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-03-24",
       revision: "37acea8052d5d27e7f1312d9e6e743a9da176c21"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611d0c0b8be66385293dd89a324419855e280927a949b2d56ce434d886e38761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4196d89cfb442a2a908155c8f8ce89d93cb4c2991a5e7b7a87e03b46da28a946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "909890ac8649d5abab394e598bdc768965d924fee4361ff08d5e3b6b64fa59e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "08dbc29ef049639ccd11fa0370c0639a5f0ef8cdaa4db4860909dfeec6a592b6"
    sha256 cellar: :any_skip_relocation, ventura:       "1b516fe47919ded8d269ec2f7f13896c2465ffd6ec8a14c0d6ebc43e4fce9077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6e9fc96abd0f63cffe897ac2627c706dbaf31b643753fb0c0e897ae066e5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b31baddbf08a7016cfff6a10d2afaad6898e0fd6bb1d95d002e66091967025e"
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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:devnull",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end