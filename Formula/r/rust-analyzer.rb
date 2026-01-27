class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-01-26",
      revision: "2532c48f1ed25de1b90d0287c364ee4f306bec0e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b51b41a24eab4c0211abc2ee7477bd2f72c14498e2ad4ff8acac7e785ec2d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88943d0eaf529a33d3a4dafa27e56a488db7bf29db5ef7e232ce9e0935d8a734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f254ed8e97b589390fccdc4390fbd2f38f311518ad53975c4250d9bad38a47d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd2cdc670ec37875fbccf82bbdae378320e2d5e7de60b0220d970d97da60653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50282e501ed27d9dc776d30c4eeddfa2d734232212386eb43951af199b50f633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0578f2a4981ab1a4d3dce52fe2598f7fbecf4c2571575951b108f62bfc071000"
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