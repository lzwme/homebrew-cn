class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-04-28",
       revision: "d8887c0758bbd2d5f752d5bd405d4491e90e7ed6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4882a0cef8a9839078138b5642252286c011f0ce59a080cea04f576d07a84ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f49ea5104c3f4b6a2cb78f6edce38033fd8bf80aa5406f07635151a681219e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "255d5f0e429059ee727a7fd91d1bc80be26ed9f409ea3de47bc89b4e487d7fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ef2bf306111c7e936e14592ab1c12f4d561fb1988f0bef41d1f97fb7a8d6005"
    sha256 cellar: :any_skip_relocation, ventura:       "62230da1417e00651de6348960706bf7d8e29fe7c4428e014410f5bf854be9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c50afda13d23f78b8455502bf77251f578d77c760e237876a07df95a532eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e2469209012bbfcb7397062d8218c90be236784999ce0163913bf0c92d8d2a"
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