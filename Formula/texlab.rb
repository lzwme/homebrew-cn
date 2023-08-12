class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.9.1.tar.gz"
  sha256 "bed004908cf1084c02a60747977f16071580fd8a1cd0c543ca1b3e1aa93f0e14"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7b17cc959892b5137d4849c22e2856d302d7a80058baf56b6f7337c02eae07d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eef2a22ed3ff0dc95833f35ac9681bdef08c261d3b22365d117284d21143518e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8100b06edf7b3e65c1e57dab89fab8c8beefc94ed307da12922dba6c1220e753"
    sha256 cellar: :any_skip_relocation, ventura:        "a53c97a99430df046751e11eec886f53997b85e7fbcf20b7f21f3c39116e9074"
    sha256 cellar: :any_skip_relocation, monterey:       "5c4d66cbeb705fbee7aee66b6cab4c2e846a4d5f3670919bd65a8fc47851dba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c81fb4e94f452615105e8306dfdcfe63f874dd9c6c5df625fb25a064bf0e7b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a419f1fae29f19b24e92b4d29ae052ff5318e83472cec1676147dc2b84ee5c7"
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