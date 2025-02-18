class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-02-17",
       revision: "84b6936e0856d0cac8d616c5ba3306155d8b3b1d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e31ab4c54893e916f4b55b7ae32db8feb343252e70d32dadd2b04ef1ccaa94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71dfca9bb77b60711f25cffc8e7eb77a3a4768202166fb3917ed609093b35094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2633cde5de87193aceb032c61cf837666c85de9b40db98b7e2f6edc9b5dbafff"
    sha256 cellar: :any_skip_relocation, sonoma:        "395192bcc6edddcf17aa3deebafd5f3693740996e1752b6f112752c515a61a97"
    sha256 cellar: :any_skip_relocation, ventura:       "4204b43f0d83274ca8c98ff1eeba6484b08c12829028c16370288ae609158a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9348c45e9f79ce1ee6a17534e750bf6347a8c43127c281b5ff6ff727bbe2d725"
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