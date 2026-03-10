class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-03-09",
      revision: "51966da92da795f1cda89bef70d7c61266d4123a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7f1607843aaa89c09f739940665ff3151f0444d38a132c5ed891711f4dfc53a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c29b2dfd83cb7e105d069f345f12307452c77a4cebacc8224058d0df1f86a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a7f2f19690044fe1c85fd961ddf078e6531a011b479dece3480fe16e8c76fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba8191c54b63e113d8bb7ece66f67bd1617df0ce344cebb698b65baa67d9ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e23d96abfa2254a39634348e308fac9e026f0c32db7b65625924873a3d32c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8871dab147c5699e41e916d409d9a5855187d88907bf4abbcb58edeebc89be6"
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