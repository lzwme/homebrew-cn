class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.9.0.tar.gz"
  sha256 "93f442c75751890d9f7e3409593926451c38aa4212b5e9454a2bde2191fccde5"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22918a8fa657647058a53e20baccfeaee702e202fe6b6a51a00dfc47ddde1b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6f7e49610cc22935b0b049c04cd13e70d6f3905ed421cd47037baa47b5e1e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1da26356d0724103edbee534818c76cd5d5d623e30282a4d4b1589930ab228df"
    sha256 cellar: :any_skip_relocation, ventura:        "09abf08f56540eb6cf6b60476d466de2e5273a5477f61e56d8fc9f301df308e8"
    sha256 cellar: :any_skip_relocation, monterey:       "2badc630a85a252e56be3dbcbe6e97a73b8b9c53d79e1f2e23b78592815947ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ca4e12998a431b874d6ecf9b2ccf2bad596ed4a3a7dae690045dd41d95de2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "610c6b201e7f8dafa28890bcbac77ccf03183b9ffa9c54a495fe5aa4802a78d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
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

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end