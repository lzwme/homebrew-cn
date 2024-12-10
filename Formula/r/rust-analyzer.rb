class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-12-09",
       revision: "4c755e62a617eeeef3066994731ce1cdd16504ac"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a4cc4f5ea2912178f539759a1ae7d6b4610d063b230484c61c03758ab855602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb79f9411b7f22dd2163fb8663a63d6a1574f1f508f4d9a9daecece3fa9e9db3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96587f3ac6d8eabe18d87ba9b1ceff4fe00233ac5a4faba111a153196a716cea"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a86c2dc8c73dad1510f41b1d613fabea3d1b0f6f6a9aebed1ab19ac90baef63"
    sha256 cellar: :any_skip_relocation, ventura:       "b2098466ef1116c68687f56a2160c5457615c91952d0684047cf63737a164ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e374c14d7eaafcebd840d1019b854693c73c8d29202486cd60580e3a72b90f"
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