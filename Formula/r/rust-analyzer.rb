class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-07-22",
       revision: "4afe0d5393cdedde58881295752fe68acb3148ae"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bdeac014d126db833ff517d0da7241b527a44f867b69b20738714279ed4e8c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051491ad03c011a2277f070c254093e39fe4fba1bb5d2567dab497082f7dcbd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b8d5471bb0c3983a063a71d469b4be510339f5deffea41e322cafe4ffaa2fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bc0b5e4f6ecb7b47f02be02fc20ca9fcf036006e65c2bd93c9ab78b4f71a3c8"
    sha256 cellar: :any_skip_relocation, ventura:        "2e070a225e9e128c25ddd76aa99b6c169e4e6dcc8fedbe4cf493fd8f86afc152"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f57842c073d5d3925cf6c47f710ff7fef89a64cbd6cea1b92a8c398cfcaf96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4cf187a80055a13d514cef50b58bc65dcfcf4d609cf414021985692b000d68"
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

    assert_match output, pipe_output("#{bin}rust-analyzer", input, 0)
  end
end