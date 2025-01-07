class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-01-06",
       revision: "3f2bbe9fed9aba5e34c33d3e44898a332df157b2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02d98219a6188536ced4578d9b0d76a8681e2350a48105ae912f7a57e5c1cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff20e210969d4c994ccb604daac02b3e7a59b89ece84459a63cb22521b904735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad95e92b8fedb64a2a421bf170462f93a1e0118746b830161057bc568dea512f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7125c907be594d7aa6159bebede80868752282bdb2fb9702e197d3bcacc5758e"
    sha256 cellar: :any_skip_relocation, ventura:       "35e85dec3e940994b0461b49dac0f827de7af6f17e719f6c8ca73ffd02e359af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73da40691a60fc34e4ea00f7c266190ca81b049d9022d267fbb210b8e0b8ea21"
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