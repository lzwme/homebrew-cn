class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.4.2.tar.gz"
  sha256 "1771f5492938c092ce9cc022b0b2bc5eeabaa2b8d8e9016988f8f8bd3f3e4270"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d867d12d2162e4acb8fbb4e37c412e90397e89cddbae975eea069102c8375731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "938316575c1d598a5e45aee6dccdfb737bc9ba42d1945cff66f92ebe6c735156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c19b6389260f7f82b1b697c226ed1da8d62bb55f944060d484538e954f18e53d"
    sha256 cellar: :any_skip_relocation, ventura:        "daee785eb07ba82e3a949e3faa72f46235fc659538c75902585cb4ca990c9b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "b3339ac769337bff32edd196dc07061385f227b71833dc06c58fd9b06f43ad74"
    sha256 cellar: :any_skip_relocation, big_sur:        "59baa7838a0346b4860cd9997bd2e07d5aa82d4b3c0ef43f5b947a70a1d19823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbd5f17678f272b176418e6d9ce8b127714468d2c0833a8ee3b376d1c11f29b"
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