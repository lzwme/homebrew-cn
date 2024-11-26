class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https:rust-analyzer.github.io"
  url "https:github.comrust-langrust-analyzer.git",
       tag:      "2024-11-25",
       revision: "327ab2958fe5d4a54c8e8f1096fd67862786af2e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67ce8c1c0803b87d9af05a86c4631889ce9f4ee11045de062926759fb743e76b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ded402c535276c8ea311cdfa03bf81b9a3d8b2e78e183a19f59bffb0b5d3305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27922390acbbe7a1e1a71d41d62d1bbd55dd9f783647bcebb46ac272694da9b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fc7d4b13239fb306eff0db5c0b464bb1f5357126e4087c2756434aafd81c22"
    sha256 cellar: :any_skip_relocation, ventura:       "439bbc3c45d38fff4059e513548a72c11da71f462c55fa4d551ae1124285ee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a336d574a25bd122f6b1fdd3d3e4276de9243de25130c6ecd26c4290673ed4"
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