class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:texlab.netlify.com"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.12.1.tar.gz"
  sha256 "008db560759f207c31001dab94beb2229f0d263f86f4703f07d8eb8fc93e12c9"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d48adfa8567c068ba03d766febfb752fed9d3da93327636fc05d8416a776446"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c44e25e8df540e70692abe09ae72e71935e5146553c0c69e4c137cf1a3514a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef6ea2f10c8379c8d8054599013f27dd2c05d74917c2120007d586598e9d58e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee09ef1bfdd8b3fda3a45929ef56bb37253c0e2f827b311d2f933e64804e19c9"
    sha256 cellar: :any_skip_relocation, ventura:        "d1bf4d7f4dc43b13aa65a7da9d3a4eed5056c11d747742b73ce6dab1bbdc4a27"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb61a9612221acc8558b9a14a4a967b9bccf3b9ef3cc971a46332f847c40a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f326facea2ed2d3b3b98efc5df33b1f34181e646682121b88e80e15c69e2263"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestexlab")
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

    assert_match output, pipe_output("#{bin}texlab", input, 0)
  end
end