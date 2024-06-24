class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https:github.comlatex-lsptexlab"
  url "https:github.comlatex-lsptexlabarchiverefstagsv5.17.0.tar.gz"
  sha256 "d21868a912b3ba1ca037d1df537dfdcecbbda3a3436529dc0634cacee302d8a9"
  license "GPL-3.0-only"
  head "https:github.comlatex-lsptexlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f29ea57dab4932b810b951ca7107be82740a7ca56d10f64fb94593929247da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e402eaef206ad2fbd6043721c8e845ba180158f74f48ec56b55092e42f3880c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c914201ce2f9e5e7d5bfd585fa82eccbb65236e71e68829ccd9a9ac50d33f401"
    sha256 cellar: :any_skip_relocation, sonoma:         "c685585418837d831fb40f1fc1fca88204eb37da8c190b2f7c17967bf1857824"
    sha256 cellar: :any_skip_relocation, ventura:        "d03078164f8f48897213958b50aa808330c05f3b9b7ca7a91290d72490fba838"
    sha256 cellar: :any_skip_relocation, monterey:       "9b841a2cffc720f7b7fc03b341fa6d80a13d3abcd81276085c508368b7a55a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "061653e3db3c3ad36497cc8dc8da5f54265601d1fba502f4693e730f1f5807a2"
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