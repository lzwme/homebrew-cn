class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-11-20",
       revision: "255eed40c45fcf108ba844b4ad126bdc4e7a18df"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5aa09b7743c55ca7c7d9a1b2bdbb9ea81cb571766ab778da761085e0a000e882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36bf5abc47e9a92854fddd15adfc12361838fceb1de4a5a62a9dd1eea76c88dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce7ef06e4a5df57eac2c7410083433a527aafc13cf6ffe3a9d25ba2e6b37fbf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "47f955003b429ca8238243320b1b0408a6e75d20a746c78630e5a661f5a02785"
    sha256 cellar: :any_skip_relocation, ventura:        "1bb8a85d12351018b39a351abd91244e6354b43acaa1eba45a7d031fb43503ce"
    sha256 cellar: :any_skip_relocation, monterey:       "9b42c4633bc69719761b949259054a4c9cbb300ac320568d8c002c405c7d09d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4834be203db6332f3695b382291a6bd8b4a3f6b1669ea232f85c8e27815a84d3"
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