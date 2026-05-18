class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-05-18",
      revision: "ce81cf65580fb7a52d9f9a896092746356f39320"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a29580b501ff5b3cc8beb11e53fac4a4f383a403167788e56e5255bac7d612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f485ee5c0c7523eb32fe1ac5dadd8c7827f3c1f1b2f2403ba7b00bf9bc59ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429977db0d1d1894bac7a7378a4ae7fdef4fbf2809d3c1dd04d3f077dfd9c68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f9db8d76b75ed831384e52cdd3624c9269988e68dcac7374b94225221fba34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c24bfa5ad352afe2c607cb05d0eb142f6982baba1137fc7abe5ecda6edaaa17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2220b56ceaa22efd793883d43c842d2ed847d292c83bed468764ffe4a53a06f"
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