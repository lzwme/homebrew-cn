class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-28",
       revision: "1f86729f29ea50e8491a1516422df4fd3d1277b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c04a6197cbdb1788f6842dfaf71dd53855ac84d79f6f6ee1020e6ee247fcc09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8d9d25d979443bcce474f6bda166bda058f31b887f71ccc15c3840a6ae1168"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59705bbc2f34b995baad6c6a3aec86e59f1675f114ab82b3191b10a332792e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "9909633b6cf5e04046675990f0416b4d8c776f564f790d8e8a035ef0b96ba4fb"
    sha256 cellar: :any_skip_relocation, ventura:       "144de5fe2b12a05f5326ba7d46bbd5795b40a92adcfb7f7904648bc89a0bd5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9dfcd5392c489e4bb642eb80d940514dd4b83a02e317ebc88e92d5ed3eeaa95"
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