class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-09-28",
      revision: "03fcb77246f2568adb0e9b2fa60d19c6cc1686f4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1fa0f5fb537e7f687607c6b6d4204f16894188d5ceec93259e0567417229df3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "425074e7a88d916df0ca9f3a45c8d4ccaf929ce5f2b5d239be1c43a623b8cef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0eb0dbd3873eb24e7b856ca19ab03a30cc9b2d3fa219a0be2dc823bda23b9e96"
    sha256 cellar: :any,                 arm64_linux:       "09dd419717e96d8a74f05c2fc3bc55b35b7be96bbbd998f7d1a42e72d329bdab"
    sha256 cellar: :any,                 x86_64_linux:      "4346ffe13d6b0f404290bdcd1522fd1566ce775387d71e6e610a5c9fe44c1d2a"
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