class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-06-16",
      revision: "a207299344bf7797e4253c3f6130313e33c2ba6f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e765006a8b7f1aedf64534b16b747dc7d21765208422fed6173a6b30f755a101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e08421a0a79221fd31c4a4ef64ce5f553beaeb5e8ddb0ba99a51412a943a1203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbdf7a3d1af15029271efa2ac9bf7e3a7e4d3f815d170bff55bbbd6897ef4312"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c47b67af32259b8b233a7db645ae14a52a01db65f6f0083362f62e091b469c"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cfebe82edd45134a63753866645ba39685aa08ffc241ae5709b884826f7892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25655988305a76d7c14f2357dccf75f252a1cfbd098ead6ebbebddfa5b44cda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2a16071ee733ed075a7bcdd9a0e8636c8c8694aa9173db6eacbccd3c8e393d"
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