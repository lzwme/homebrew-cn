class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "61662cab58931b0865372cb1d32efb4701237cd50d77c0888d619a8ec3765e01"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bacfd9eac6f59165145bc9d928410d10f5a3604a264194bd087f6b515ee8e66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de59cdbb3c19589d04f44b610b57e1e36cf336d280a18aaa3dfd5a927432866a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ff8bfef8542021db376627db909b9b78360c4538f2deebce07862e8e8e5e85"
    sha256 cellar: :any_skip_relocation, sonoma:         "00a7f550d991f9d65392689abadd007ad20216eeb7f89120c4f48aa946024885"
    sha256 cellar: :any_skip_relocation, ventura:        "bf3358a3b3404e5060c3a08ca13746fa8cac7c419c1800f74dbd3edca14666f1"
    sha256 cellar: :any_skip_relocation, monterey:       "227dd759db6bc1c19f478f20ccfbe81d5c1984d7d34a6bf9fcd6f022cf90c345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fe8b79d690c6c4826d018f187af8bba7e57514de99737ddd807751e7c4d01a"
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