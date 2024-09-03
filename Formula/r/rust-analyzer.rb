class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-09-02",
       revision: "779d9eee2ea403da447278a7007c9627c8878856"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff83bc2b42f61739e2e5a51489738c0b17b9d27e0fb3318ef308249bff6f775d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12ff38c2b7cd8f6693efbc30362d4fd29bf62daa8e9d3b64c38ed79c1d65f5b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91fa8ac2eaa944f94836d0bbdedc3ed881bb14f96b05b6db3bafffe187261da3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6699bc6fca8ab2d52247c68d8260aa2cd25f63187c421fd28f652b01ebc73824"
    sha256 cellar: :any_skip_relocation, ventura:        "c936b96b2e161577d90f8ba22cb1a38e9904065288501ecbe886aca3ab17144a"
    sha256 cellar: :any_skip_relocation, monterey:       "cdd0766b2e0c03a82bf6080bd4856aebbdb9b2b74329ba88206de2a4779ad11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06be2e67ba19d4eac70ed18c50ded80fdbb2f9d00481c6fd8925c7d8e6b82609"
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

    assert_match output, pipe_output(bin"rust-analyzer", input, 0)
  end
end