class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-12-30",
       revision: "59bc7b49d0ad319de8c477c63da552cbc8a05e4c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e8f455b1fb8476d18b611a282df005293b77137ebf988772d02535f6cdbc5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44822489b78ffbccec5f8d5fd85dec40b40517a84716c825295fa8c773517e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9da0633dbf7e5fa4fc70b652b1b347cccccf8c0dfce5bdbc7cb67bb496f99795"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc55c985030057ad184514d2556c5f87541537cd782c9b9cde2d7de56b2db707"
    sha256 cellar: :any_skip_relocation, ventura:       "58b4ffa479504a494ec3c4f00ff609be412c82e663bad11872302f463609ec34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59678655ce9a851b5113ed0ddaab520cc36844263e8dc3f060edafdcd636e188"
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