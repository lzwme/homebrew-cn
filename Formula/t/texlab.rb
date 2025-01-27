class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:github.comlatex-lsptexlab"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.22.0.tar.gz"
  sha256 "dfca5bc12419e771092b6bdaf9379fe04164848ff19054d4ec7c4bba0eef7021"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d2886455c9305febdd732733898fd45c9cb53813f8c2e5e46b00e5fa22d4d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07a1dd2a96b0ebc040a9c51198bf83ae790c63508dadf7db7812b9bfaaa4d80c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e542b25e70aa86d3508dee9248167f37660a557e0fffca637b034b9833bf596"
    sha256 cellar: :any_skip_relocation, sonoma:        "552c864153ada89e52c8389eac9d5705ef184c8d4e4317c6ed1a0c32fd1d08c2"
    sha256 cellar: :any_skip_relocation, ventura:       "218a0ab89376f59d5a7a566658b590799fd82626f766a3ca61d35f7e517c0bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef8d3d76b64de9f9542ba9cc427c74bd9b5500e358dce323d969c7c8279b123"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestexlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:devnull",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = Content-Length: \d+\r\n\r\n

    assert_match output, pipe_output(bin"texlab", input, 0)
  end
end