class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.8.0.tar.gz"
  sha256 "55c9dde1bf9c09b4ff635fee339bef0c136dfd67c2e85d0b712dd5ff22883ea8"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7cf72667c54cc8785484098da05e170c4c244fc8d06a5358913c757de3debb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5fe86704cd693d1b424ded75370a162476b33429218ca4587ce23c9fc6e23ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15e013e8b2142c7dafd553d80cc6c5a0cc7bdd45cd8fbeefaae0626072cfd60f"
    sha256 cellar: :any_skip_relocation, ventura:        "b59043ee148506cf896496f1925a7dcecdfb90199820c487a60d57c7c80ff335"
    sha256 cellar: :any_skip_relocation, monterey:       "184082455e64d0770b8d783db45c3ac2cbd7a8db4ed233c7a13dd1926c587658"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1dbd9052e7256acc3f180d77f12e52bfc3678b4dcf53bc41f606526c3be17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a1781c7903e1e192207a03a64749bc0170c281219f3f0bb648e5b8d0a7f0f6"
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