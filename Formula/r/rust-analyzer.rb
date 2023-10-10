class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-10-09",
       revision: "b1f89a84ab350091e6c20cfe30c2fab8d76b80e4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a0068f14d7c1ff0f5fce311232d453bc926f12fad60377b5f54af0ab2b453a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "502bb5a881775f420b46cebf9e5811945768a20795fd47b293b9c90c2b92d664"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d9442e01e5eb9e335378e2ea1999721ba6ce28bcfcf5f16afcb2e85d7282f9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "14c531bfe42730f06ba3d98d92f65afefa5675672127f2727ad94b6c41fa9b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "ec99db5f16f215fc24ef66959fad712f0b8e59cc6f0aabdedf19416ed17153e3"
    sha256 cellar: :any_skip_relocation, monterey:       "d56ea6d516189139e4d80cc254c6cc532da6ff934172b1a4cd84acafba920727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a546475b8b118f9d381eef51a28245de37a4901bf2b3f110ee798dbf802b0be3"
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