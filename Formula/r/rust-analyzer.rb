class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-07-27",
      revision: "12c3381f0b17b8eec21075d1c72fd010996a9bda"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fb861a53039f92b8793e677e66e12412666104eeefb597a97fd48e9e97387ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d9983f18935f72a0242410528f39949050af74a0882c96cd7a821284979f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96cd33ccd90b0f8d6220f38115b591c7cc29288cc9b925e7c85a183b3060633"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7f4623e08a8f1916eaa12091e2df7835602aecf5dd46e103dde3f0fc0fa6cae"
    sha256 cellar: :any,                 arm64_linux:   "69d276265b3d9ab109a584a4a783b1c92416a5b242cdb7c467d2d3161be1f6f5"
    sha256 cellar: :any,                 x86_64_linux:  "3bc01f07be6e06de0047cb8f557fecc537ea19848a878b0286862dd3ce116a5a"
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