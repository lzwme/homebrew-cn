class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-07-28",
      revision: "db02cdc7fc8b0e0b9aa1be4110a74620bbac1f98"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a306e60e05215b34a041d5deb7bafb3a1f06c7009cb0681b64872aa9676cff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a8d9d5e6e666e809af1f18cc085dc8ea0aabf4bae542a7007c91320dc58b78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9aa36e546a822b1db8fca056f90e93a308c55ae4ee52cab1fd437c6c5ef763b"
    sha256 cellar: :any_skip_relocation, sonoma:        "887427f352cdd0b0de5a5c394227a004bbd553c1ec49d1afbc69bac25ffb95ff"
    sha256 cellar: :any_skip_relocation, ventura:       "11fdc93dbcc5c5d46d7c58ca255b8ae440d85e4c61f8fd8ede04eb715f7acd6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac58f0fa7c6c21a706d53ec08bedbe030788a8854a72f693007926d6e3ae1b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e730ae64b71d3d3d1a7b80e7893cdd81131d4d24482424434d8d8d861af6f8a"
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