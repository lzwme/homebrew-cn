class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-05-25",
      revision: "de5824b6d0457b0e35cb77de2c0d99402d63770f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2ec17acf3a5f249366e146393ea74540d0bc291f4121dfbdc8c5f66d6857095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dffeae9615ec10a16ccc3961186c1953940fd3cf68289a3e418cdff99333fb9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1ab29096a7e554638083e8e28dd7636e461a448fe32e405c9d35a5075f284a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b578d5c7b76129d51e162d54247c8d338f1b546e7a2d9b9a4fc0842425ad442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c022be65abc372e184a8b3b763f2c62f5398f6eff08a21f24f9c2f7776e8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5881f32c47d95027ee554c2364c4707dc7b1c052d1fdaf5c060965c2f73b0f26"
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