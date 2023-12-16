class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-12-11",
       revision: "457b966b171b09a7e57acb710fbca29a4b3526f0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c14ce3325fa5e18a4ec2a1713c15b6cfba9f29a2b2d6bc71dde60e70b12f6d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36eab5f5b8d76d3f607424b001ac12ec0eff5db9b9bec870975073ed6749f5be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d083d88c6808e4a290346e8c3b8df956c08591a51c3f2adf645cf7b0e6e0cc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fdbe19671586592fdcdd2b30b9ce60f1d7a9ef618eb95706c1d1d251969421f"
    sha256 cellar: :any_skip_relocation, ventura:        "da4e716ff445ed041d6a7fa2a15c70858f84cbd1382a5dbfc2dd068fb7715c05"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf82772195d2852a9ed049b04765d331233ae102597bbbfa77dd8403276a484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d8cf9b7aee9a12182c7a934f902a1a341ae1e5ee23b64c5cadc06ac87266e7"
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