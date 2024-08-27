class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-08-26",
       revision: "7106cd3be50b2a43c1d9f2787bf22d4369c2b25b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a827323b167a36f9560deec7f8828f61f446b440944a0d795bcbfed2f3af649"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "362bddfda5f910ef1bb86b7b5945b8a81b2ea927e95bb3c2ed2b35edf06b60ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94db901e28dfad4d3e30389ea9e98d239a3e161a8abd6023e9adb2e8f407fa51"
    sha256 cellar: :any_skip_relocation, sonoma:         "29db354e1f42c03b31bee96def8fd54e88e80002717d63a1038e8c3672c2acb3"
    sha256 cellar: :any_skip_relocation, ventura:        "45554a98010c2456c394cfefe4be14afd5f4984a34ae508875c7e981b8a9be00"
    sha256 cellar: :any_skip_relocation, monterey:       "184d56bdef4adca2296cd08cfc9f4a144a61a4e97d1e896a99c3f276c64d8aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4f319d552f26badeb687ddcc08c4a9377b8ae129aa0b1ac8b44071673126d5"
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