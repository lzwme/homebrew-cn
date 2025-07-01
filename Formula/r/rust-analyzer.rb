class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-06-30",
      revision: "6df12139bccaaeecf6a34789e0ca799d1fe99c53"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f568bdf4ee33b6c30bb2ca2feee6a404dc8fd8a4234c2b49a0d3b269fe9e04db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ecc2198485e316addd162f437964609bae9e0ff63af7ee5a8a489a2e9e93b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da8ed629f531a241188e069c04213c83db1e3959ffb4fdc1d3b235b6b2195457"
    sha256 cellar: :any_skip_relocation, sonoma:        "393c1871368d83235bf993122b22170d6f323b0be77760861b3a02197818868a"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f1d60d2a38674ad495e4be62dbc8c74db3a571cb1c63b193e2042e40aaa1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ad7d75a6288397ad5b69733d4bb030b6ba62b4f78eadcb74969afbd76b421c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac28a7077f260700ff5050b48611240a8c3cb6885765a58f1e43559381b96cd"
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