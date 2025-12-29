class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://ghfast.top/https://github.com/latex-lsp/texlab/archive/refs/tags/v5.25.0.tar.gz"
  sha256 "95918caccd598ba47adb867fceb414ab26058ee45369da9131bc048ef920017e"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d97a5defcff8fa11429602e3457e64e21b342e9a8354dbfdd9d802de18f5a163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f226e5d03c611d4c5cd399ad55524ad70bb190dcb086b8a4851432182991dcf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04fedd9acd24d4bbd765cc082e262c33e69f0ddcc58b3fff3147775cf5918262"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd93457e8b52a07743c9808db745cb3f7c94b989e118224227f7ce68a2527b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7bd74f85089f9eccddcb3cd6ec408dad2b823fef40998094b8e4dce590a1060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bba150cb3a85837026361306bf52d2ca09ef33569218485dfb4f7d35028133f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
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
          "rootUri": "file:/dev/null",
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end