class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://ghproxy.com/https://github.com/latex-lsp/texlab/archive/v5.6.0.tar.gz"
  sha256 "16d7bf4c4e3a25cf1a9cd2ccfea2315c7c03cd3705de50f179133a25b1f0ae30"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07dcf973037df1ed3cdbfd08d6776117d9cb82f7294c95d3b620c6fb5203e86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec6a21a76e8a9ac13353de7aa0b3d413dbfc10c906c6fec0856f2cc4e752a14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966f67a31557d3026361470cafc9d7d933777cad112d827992d1724d1818f4ed"
    sha256 cellar: :any_skip_relocation, ventura:        "be086be2f83a0d96f7bffb1deeea0e735a9a694f57a8315c42b4d3fac500559e"
    sha256 cellar: :any_skip_relocation, monterey:       "c600ddd8f7260bf131bc41eaef7c1550547b3d7495b9a82471a6009142dc83ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c3c38cc5c2a96a2e952e218da076b7e94e8af3c275f96bdda3fc74d001c4914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d8a8aa1be7c3818948c1f4347bad6cf88779972bfb5aecdf0c697a65fccc11"
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