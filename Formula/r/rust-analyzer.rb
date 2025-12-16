class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2025-12-15",
      revision: "87cf6631c60b7e7c9f4a53693a68920a80966c6f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c2fcd00e61eb77e3e784e6abca885a6c5725e27a3fc1f37c6f6f196e96714c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ea0d13f7ca65f885da87314da1690bb481dd8e32a3815317d478941b7e48db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b1b8a0e28e7b47c6318c54b7e9a692cdabe3dc8278a034a201388507da258d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4aa0c7739e17b590d9069dc0526822d2996c95ecc321799179bbbc183b51cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2d1c7f6a6a9eb208f7f75c8e7321d0fd4fa9270041e2802c6b483ef903937f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00841a1bbb744569372583ecd5239937c22fb50f5cb16cd4b494e8422b5af342"
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