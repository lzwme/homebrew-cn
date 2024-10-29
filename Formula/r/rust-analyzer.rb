class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-10-28",
       revision: "3b3a87fe9bd3f2a79942babc1d1e385b6805c384"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f4d7b1363328f3df515c300487d80868a35e1a0e0ec3bffa01169976f8594d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4ae90b0b16999467b86279313558cdfb00c4610ee02f35309e1b784e5d8350"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d701ebd5283205b03ebd7059b3ba178aa51661cf4a345cc33ecac7e208e144e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eda6275fe2110adb6d181ac2e8ee4f09809d789faa0718254f092193a2b5cc8"
    sha256 cellar: :any_skip_relocation, ventura:       "08f946323607561fdb85c0f14b30d28e1c1f429a7323cb3d52bdcb880b0c4a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11a436a5536d2424f76e59874ad09c9c980f3f53f086414158f73d1784db6d0"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:devnull",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end