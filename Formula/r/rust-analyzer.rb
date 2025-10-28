class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-10-27",
      revision: "049767e6faa84b2d1a951d8f227e6ebd99d728a2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c194eb16aecc9e386f4d25c3659acb1c9a06752fe626125f875701adcd87c17b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6971ad7e757ce4651919e90f2d91fccfdd7b93f76cdfdb2cf5fa931c411d57b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb61f03b18747527ef200af08705423422cbf654bd337e83b0ce6eda2327c9bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ce593c7b2369b2592801d510ece48e031aff64fb7b219bcadfbc0923b9f08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acf18d27c4bc6053f91dab8d039123c9f13c01a9a8351971b86c781a4f0c2631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff0e61df50a4c6671fa34321acb01b42cbb5641ce3c7fa6de170ddaf7f7fc137"
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