class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-07-10",
       revision: "ff15634831f4a3cdb8abf5690a9848a6fdf48432"
  version "2023-07-10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58f8fd71be33d07ab29cb6684330b3959c677b2625e062b4097f4c2fee96211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85958747bf0d709ae162cc7d209ab5381723858119507ecf4a37022d005f9a27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "786b2ef4b6ca6a68d76bb68f176ce23fb21e2007556d174375da1708f9e91dc2"
    sha256 cellar: :any_skip_relocation, ventura:        "f791e7ebaabb362f0540a9054c4222c2fd0b8c1f1fe87113cb54ce413c4aa886"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d3bec956ec17a2aa28984b42aed5b5b7be7ef4cff7efc839997291f8c9e4a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ef05ca35e2c61ce476fae3b2b475955622300b306f8dda2606151541f90d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ff3bce6514bc4a1aa4a65e158c9f749539dae5270bad26b307b5f4e1e18949"
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