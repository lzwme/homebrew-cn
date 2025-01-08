class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-07",
       revision: "cd12ef8547d3a760461b5361cb81ca4084197232"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b181f6bc83eb621d0819d3f3f88b5b971bd3e939fb251549529231ce1a6e0b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6abf4f146ed371b8d099fcd061350d233294461fc120705e15add848221d70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d02ac48a1bbf42a7e96c401dba461df5aa888fbcc30070a204926846350fd8f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e5859ff3a6322b7cf28f2bd546b59b650e631d2f7736c260eff7edf70e74b6"
    sha256 cellar: :any_skip_relocation, ventura:       "c9a21fafe7dd2b6bfc50877f902d0a2f3e4f5cb7b384b16e2b6b91aba6ead453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34428c0f1f09a729c9ce2207b1601b5c9bcf8c3e9d86ac28a58609eabb59d1bb"
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