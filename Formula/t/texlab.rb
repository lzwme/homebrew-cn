class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.10.0.tar.gz"
  sha256 "af327ac35b1803d1b9831abf915b9bbd9f18d8659facfb72f820e006b60bfa41"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd88148a4dcc160688a22bf7bdbb793f228907f9c08490c4814ec53849ba76fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84957a14b1dd74ae644034d560ccc7168bd45eb7284dbd4dcb7de001c857b79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96754ebeb1150e0304c5cef06e6b7207583bd4c030bddb8389f367dd60070ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "b23ce5c56e3aa726da082caa562bcd7b6dd176b50831181a32082fbc48ce6362"
    sha256 cellar: :any_skip_relocation, ventura:        "da4250d0aab7bf26adb596edbb375718d2fc7de4da396d1e068c641dde86bc45"
    sha256 cellar: :any_skip_relocation, monterey:       "8fbd61fd5c97d9b5e6ffa615f1b35ea6e123171b0f55f7734cdcb1cf6ad13ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb553ec0cd73cd070e24f2da02bc1871d1359eb2e26f929719978f8ba6328c2b"
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