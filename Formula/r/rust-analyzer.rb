class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2025-03-03",
       revision: "81ff38f53b9a14ac608feb30b21ed42a41d016c6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da232c282d4251350ce29528da0d55955bc8f622eeb2186ea7ed7b69671733da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ef9d7c7cf5a5f32640a1d0672623df083ef984ef61b6f861bf3316f59ceb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f31705611bedeb9b1979e9f157636c61ece4b56d9ab72c7f6034ab20a52d74d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8799deda303b85be829ccfc82439df0cee9813e4a4b59d121ea7bd38d5b14d"
    sha256 cellar: :any_skip_relocation, ventura:       "d271a0056e8d677883a97e3ccc17c03ee931b2d5f4793fde0f59957b69ae22b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2b7a77444f6fbb1b6f1e82af2532642f9b71759398225b2d1a1c46b903629b"
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