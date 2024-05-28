class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-05-27",
       revision: "71a816a90facb6546a0a06010da17598e11812f7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "455a376998d54227cb32893d953018925399aab3827d6104e19ba2389e79e90a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5244d7ded6be31b2ab4c2160cf4db8442e71d58519ac7cd1559396387d78725"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb1441a948f4b5ec77acb08f48eb4ce04b71a22190c6fce5140c7467563d85a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8a900185cc8af48b19b9465f4834294678bdc959eb32210c0887eb7fb7356fb"
    sha256 cellar: :any_skip_relocation, ventura:        "2ef59c3e2f920b8c48dbc85bb32be49dc36bace9d18b6a54e5625c82eaf5fbaf"
    sha256 cellar: :any_skip_relocation, monterey:       "6fec36d9406405579af44df8983e11bb9aa83b83dfd01020be7337c0f3830507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f08bc9f4866beda236d7bb4d9c4b4e2d519b45f9ee0bfbfb4d88ddb630e02c"
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