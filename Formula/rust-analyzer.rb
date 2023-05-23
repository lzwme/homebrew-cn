class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-05-22",
       revision: "7ac161ce77dfa31dc39337c2543a1d777e70c16e"
  version "2023-05-22"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5dfc660047b818d7a6883cbf94c65bd40190ee37b07f55415d418db4d784ab2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f8dce683e82fb95accc9f72e056538156f99984136feb09efe20047ec41d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d09ed4c61fa159b02dedab7db2402f53f193d83e7db1e864a9dba99ad3d0818"
    sha256 cellar: :any_skip_relocation, ventura:        "f6ae0872b38c1144f00ea1ac3e49aea35c53255d9a8a40cb1d78c4dce047f289"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc3e9e57d831df2050b6d38294c20a9bfc933edc122c1aa66c8b5bca3bb6b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cf6404658c3a182ec1d524ee010b462121fb48ca0aef729bd130aff7ca7bf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40c86658b10bce85d5e88fef94ef23a8034af415d32ea2962e099db2fbba359"
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