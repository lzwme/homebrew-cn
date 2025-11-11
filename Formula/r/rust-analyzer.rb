class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-11-10",
      revision: "21f8445ea523e83cd4f11b0a67a3a5ced2b1f56f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b478fbc329933df5416295c9b5e2fb3a8c5099133a123b4cf36a6d2c0ecae621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c56adf5c920b33af2477b0c5a11cf08c91cd3fb5ce7b8ba7fe601922aca75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c5defac9a12d63ad7f968291f2b5f46cf565a72a29c69e802ed89f573988091"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3d864f4dd0483fa7a352803d2951909a9371c5bd2ae682d55c4ff2d6e24866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73fa09f5df38aff9b291e4b6239992923090ba416ae3ea914693912097a427f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acd006520aae3bbff49b9a9803191c8e6e6d6f271eb6aec398838dfd1d3253f"
  end

  depends_on "rust" => :build

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