class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-10-05",
      revision: "65ac641199d5b0dacb075c4db95f0bfe784d0386"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b2fada00a4d98c82de70d6ea697b72f1854b6b6ca6d3a896ecec5e9a600a974"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8561aac50b58b39bd78f4cbc2235f8fd195b67d861945aac72c9134b276b5737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5399dfa559ca295a834973b60e6e4a13673d3750088c7679219ff7fa6284a902"
    sha256 cellar: :any,                 arm64_linux:       "e54b64d07be69ef84970514e06a741ab98de30a92308bae05b491cb685ab8e18"
    sha256 cellar: :any,                 x86_64_linux:      "dc827ac43712ad4dbc6f9c46044862af7aa86e7f8260b0184b9de7eccd777c3c"
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