class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-24",
      revision: "5c156cdfb047ea171ba255dcdcd86236d98a389e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb87b085f2f8069d8854d9042b1bf2bea57eb923ef784a9ea5f63f708eaf41e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58940c94148de181a758e9d8096a08c9e6f8a61a3c7b0e726943813476dd76e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec26a22b37ba9a8addc1266ade68d7d86591cc3af1d6fdf11a7820cb68b9dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff65aebfd2f8f0eadb449e89487bf79e972ffd7dfb61f1bed8b60740edd4a6fa"
    sha256 cellar: :any,                 arm64_linux:   "fd038c00f9cce874bfc1e38ae4ad4e8b8fa3bda8ced57c104cdf297f037dcef0"
    sha256 cellar: :any,                 x86_64_linux:  "c30f152337ae688900812e9ad4277a1440eb77d0122467f752e5f50b76303e0a"
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