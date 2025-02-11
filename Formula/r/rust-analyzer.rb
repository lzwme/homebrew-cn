class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-02-10",
       revision: "35181e167efb94d5090df588e6af9f93250421f3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb4b4e0475a5756416377898c0e68ce710f2531b97ced61cdb6067abfbcf397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f4b1d91d7c7d09d453d2522356946baa4cb8371270178fa53c8066caf15773"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c6a372e07891690989da2a25ab408e7f70574be4f59f1e8e259733c97c87dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54111fc0d88497bea801b03fcb63a386772db4c88911cc12692768325a308f0"
    sha256 cellar: :any_skip_relocation, ventura:       "df3f4d6001fc4aab7362c18425af44e766cd2e6cf850ac4a45a262c5e9a017dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d3513927f0f1be18c1c2f2eaccb51835f68e8468a1f18bef6faea5e75f229f"
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