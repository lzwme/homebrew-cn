class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:texlab.netlify.com"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.15.0.tar.gz"
  sha256 "083b90d3618378838284943491a4dc093e11a611af3a07d4df48e849e50ba179"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e156051e623e4b24a2991f8b3fb87ccec32a63cb278b3f4a4e2a536887678d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a0af7d1e0eb2d8c786a8b095101c4fc5079e33ae3258c0526e5835873397b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0724f7d00a1868903a6c6ccbee69e2463a11b58091150678b1fddaca16d057e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dfdfecc38c0aa66d9ea676f8bc48909d796ada78793aae7f602247f6cb39177"
    sha256 cellar: :any_skip_relocation, ventura:        "254781c7fc1b35c48144c83815b8aadbd79dbf30c4c14544bb19e14bd16731db"
    sha256 cellar: :any_skip_relocation, monterey:       "1b108decabc5ccd4a8c0e3e2c650bc3fe18ba10a733d9e115f0ad79ead5d7a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9485813c4add0364eb17f79be58cf80227de636a820b6149989153ff8b5c7e4"
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