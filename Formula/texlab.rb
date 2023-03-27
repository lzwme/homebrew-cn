class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.4.1.tar.gz"
  sha256 "55354fb23ca222d4a80aaeedba115ce0459a7a0f76ff7a4be385bd35fd97c5fa"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fce33ba85a2b40c9cbaccac8ca69892de626eac5b31e07f80b64931f9861a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "979128919392d19a3707e941f26a7fb6cfa9db34cfcf35e4a7613deda49e5a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dddeaf044538a75e8bcef8ac7ddf4ed4ac710b49fc7901f6fa9e3a3f42b1ed28"
    sha256 cellar: :any_skip_relocation, ventura:        "e9e3835b92b11a2e559adaa98642eb2230916a01b7747667ae10929fee0e02a8"
    sha256 cellar: :any_skip_relocation, monterey:       "1bdc8b66f55d0a4c9245946ae3273df73e96e601c42808183dd61c2db66cccfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "044f3d99e948e94751a7b6a9ad2d9b1ac77c16d2043a9d18b7e4a54f28302db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d17622d8af5db526cca24d81a981320dba98f2a3bbbe1905289dcb3b3aa0a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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