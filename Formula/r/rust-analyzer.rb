class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-04-22",
       revision: "47a901b9bf1f99b1ec5222d478684fc412d526a5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3c5f581409da926b3dcb97048d3959bb2a5e7a7ecf6be6605424f3a979a66a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ba8416f6d94ae57542f1d0b4333cc461b148b6de717a0cc70a67ed9f04c1665"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94e8b3b1810b68cc96d462b2b5cdf3c4c13532baec8c14d659e5ae12e9b1180"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f7fe4a9cbc28dd3d5169487d0087cbdd4a37d2e7e230926224242b57caef37"
    sha256 cellar: :any_skip_relocation, ventura:        "d567565319a86f1ca4cf5e7f4cef42165840eac8562de412d638057a90ca2f43"
    sha256 cellar: :any_skip_relocation, monterey:       "e3e3222f900f43b3eafdfeb1e17e5b6553ff9dd4ee67f610e46a2f6570dd318f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b251615b97a591417fcf40202ed528617b09b4d964469ed485002400d7b3f3"
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