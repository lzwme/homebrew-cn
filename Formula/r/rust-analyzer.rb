class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-01-22",
       revision: "d410d4a2baf9e99b37b03dd42f06238b14374bf7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ad37dbffab969b9d7ae8d89cc7d74713586e6e3e382f3f0bc34bc53ce251882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f3fa0ac3bc5c489085cb269e14777a5a629d3a679d4d4d676464145c3f76ba2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa556ec726b1cb14bfd1aaa744796f17c1ddaa948812062afa52df406d6c5837"
    sha256 cellar: :any_skip_relocation, sonoma:         "688ddda8848709fa2d7501eb203c698417583e51cf780f565611dbd283bda8f2"
    sha256 cellar: :any_skip_relocation, ventura:        "ec37333cf16900d91b5938278d936fcad51fb088ffd2ff4b4659f09f69bfd181"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c7dce14ac8bf0250218b435c09ca7f770fecfbe8880caa115523c3ba0713fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe3e89e8884681d6fa5dab424c595711156d1a9be35d02223c10bd1819fcec1"
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