class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-06-24",
       revision: "2fd803cc13dc11aeacaa6474e3f803988a7bfe1a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "329db848ed2dce251f67961241c6eb7944e5e5471c234d8f94b0f6e8d6aa0f0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b74efd0761293737dcc3be82ecd8ff034e8a6546a624133bb715022c18d90f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135df7876ba1416e106c5883116f4f206773b9c83a87b18ce2210b67186531e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "14c4084d9ca5d1e716c1ad553859843b1d25945e3793a94eb325964f3e95ba51"
    sha256 cellar: :any_skip_relocation, ventura:        "5dd5feb7606021e02b6bde2d0fe918c0d5ba901de0b698ba616dd9b4ee14c0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "140483b161521a468e6842503563dd772fefabc1dd4ced062cbff9ac27865b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cff8ecb451e5ef3e6fcb937ffcd8fcd1731f52037d1827d2330404dc95823a"
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