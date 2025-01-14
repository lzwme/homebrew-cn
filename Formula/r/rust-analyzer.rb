class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-13",
       revision: "8364ef299790cb6ec22b9e09e873c97dbe9f2cb5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7725d57d6583a28657eb681b840334662a14718650280a99bb26bcafbc114c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a1b64ab4e016f7384a789b2d5ee6f4d24921277598a9c014489dda8b898ca3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a72b3e8b674b0f32917853611b0a92ac8fc3d4c690495f6fb979100254afbc01"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf109c20b995ac462f9639711f2ff765274c2853d473c3feae35dfe902f53c3"
    sha256 cellar: :any_skip_relocation, ventura:       "811d376a45a09d7640a132c7a957084ff6bd4c8b8d254ef46f00c656c444f7eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc72256ca376b2cd1cfa46131bd29d639b821aa782694876e5ccfe2738f198b"
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