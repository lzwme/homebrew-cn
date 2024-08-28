class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-08-27",
       revision: "0f7f68dad2e0e545150e6088f0e1964f7455e9e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9be95fc68602d228f37fb5da08b85d14ceb75a3bad748afcc3e27acdced3d0ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7408df032e1183adce13bd361221b5695d14dfaa8cd955c805b3c58fe382caad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe831af1ebcf20e1f15d3e198ca0d058cf1209808e3f5218af2f87f3833cf7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "39f10fcbd9653ddcee37beb42e9e4a25d3637d138e2a1e893ac98b1591f62815"
    sha256 cellar: :any_skip_relocation, ventura:        "1e2e924cd1fba7b5aa079e415437de7d86d5e2f868b82f35c5c604f3ba2e2925"
    sha256 cellar: :any_skip_relocation, monterey:       "59012d304e3cfbfd66517310c55acf4b59f24a4c3671c16304cbe945e6cfbe61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f3d22a943fb99198e5f860381c477231f081766ea95015945c185272e3f49b"
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