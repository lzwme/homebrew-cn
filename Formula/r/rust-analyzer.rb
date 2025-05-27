class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
      tag:      "2025-05-26",
      revision: "d2f17873ff19786a121fb3302f91779c1a1b957f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd83c51611d3e82c3aa3a8298f9e306d83052652adbeced651c9b0ab88c9bd81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caacc1e6b7eb85a6d130ac068496d82654066f5c7763e5a53485777db27de889"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b21bb2d77d1167af91167995ba65f26f47104b4f849a6d5857386469538174b"
    sha256 cellar: :any_skip_relocation, sonoma:        "068b9de4e7ae6a2fc948c074936fd45137fbe2cfbf724bd76196e81bb0a97e9f"
    sha256 cellar: :any_skip_relocation, ventura:       "06d7eeb6fef8fdb93327f89c0dd23df75566c05a3939e57ba07af33c80ee3f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2818fa35399f85ce5f6c0ff8b4d2d23544bc8b0bc4b086fe8fec60bdb2533d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f87c4663e0157bef56368cec5c356fa86c28b9b9d1bca36c6de54d63a7809287"
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