class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-05-01",
       revision: "3a27518fee5a723005299cf49e2d58a842a261ca"
  version "2023-05-01"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "408159fb60eea2eade6bd8a5771b61ebf0e8fa30225847d17fb14a22724c855e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a0cbdf6e402b9285dc7e8d7fa4372b87acfdc93ba17fda1acf05b378682e4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "840514cb6384e0e7cff29dc79a78edb53271b55f960d8b36dc8ab0535dad822f"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ef296aed42aa834c9be83c8976774d1df4d3de762153ffab1390f6fdfc3086"
    sha256 cellar: :any_skip_relocation, monterey:       "a57c13ecd710629a8cf5c8a3d040cdb28915aba936c9cd66d83982f8ebdd1646"
    sha256 cellar: :any_skip_relocation, big_sur:        "37b736f7ab6a87812f52e6f9ac4a0b9537d627550378710633fb785f21f780a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22cd904ac1e0583842d2c3fd4af55af29f44b250f2de2537775ec680a2028ccd"
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
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end