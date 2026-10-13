class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-10-12",
      revision: "2ad81e72b7e978cb800dffe1bcce5c9f98032acf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e21c3e80082f1518cbbb06428fb5d03dd43526885d8f22e37fa4c6dce18f1312"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84d758089efe6b4fa9dafaba29fd824627cbeacf5da0d6420cf6a4e1df2cf7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4189a875b020f34b5420721af6860b7879e5845bedc85b5c7b1a2fa1aa03fb1f"
    sha256 cellar: :any,                 arm64_linux:       "a3433b7e5c04292d57ab0d71a347c45adf82555fb7d2c3a2e5b2f7b9aabc9f0e"
    sha256 cellar: :any,                 x86_64_linux:      "8814fdc4e960b34a6489f704dcfb524d7a7d4f648921030234d79c3104ee01f4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end