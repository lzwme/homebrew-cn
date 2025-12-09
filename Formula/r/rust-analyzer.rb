class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-12-08",
      revision: "5e3e9c4e61bba8a5e72134b9ffefbef8f531d008"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89eba99194dbfbb774d94146b428ff9508f168f0cf3342d855b7d230b0cf5274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a128141be21c02a4be4408c1b33a49fde0af5614688b0676e23f0c4f02ee8610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281185f8ae6e1d28156d54dd319db010c4a96c7e36443bc17886a5aa02a45f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f0d1673fa05d76c5f32afe92797acf61423bde18cb95c3df6c0fa54b16d616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec45bcd5a416ffa22fd2cceebe73f7b663b22d1a56696bafe48c00b60ddb7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2323083258a4ec5f80801612efb908ba7c3b372b19fadad8766db7c5a9c98f0e"
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