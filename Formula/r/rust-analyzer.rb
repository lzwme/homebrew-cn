class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-12-04",
       revision: "e402c494b7c7d94a37c6d789a216187aaf9ccd3e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b2fcd2c67bfd5cf015c8567edf19657da635066d8c4769d239349ba98392708"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "942169f2de3d8bb85d746af36248c84085a3d3b50670d1299200d10afdd41826"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608b078d56cfda049292b789fd20d14b51cc84c7a0b0950a4a5264a2d9caf701"
    sha256 cellar: :any_skip_relocation, sonoma:         "3693beef0672d185be4e1fb1b887a72d5506fc80cad59b3f08395b3c94389d58"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e2db094bc4082f7ef8d4132dd9acde2abd3fde748949558c0d472e436a5d64"
    sha256 cellar: :any_skip_relocation, monterey:       "44e8d287bc905cd9f91148c2ad5d1a4f3558986350da7dd0a79c0e3a0c09cc76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067f6e4a0b179b502ecaf1e6797165b5b0f73187187fbc40a93b6ad9e8353c8a"
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