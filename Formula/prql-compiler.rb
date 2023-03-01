class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://ghproxy.com/https://github.com/prql/prql/archive/refs/tags/0.5.2.tar.gz"
  sha256 "27b3fe85315322dbfa3f5c7622af3a0d8a343b85910d3a0f760f4ebb9246be52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff87c25ace2699a868f2b782bb1a7c07bf4458686794ef69f9ca5b4641a743e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a28a5a726ad9aca994343eb1955ea15fa2d3f8b562ec157cb422f9b78f1695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b32b63b0644ec503c73913fd90dbb5a8948f05fa9cb6491e0ab60b74ef3c084e"
    sha256 cellar: :any_skip_relocation, ventura:        "91e0c650cecb0b6eeb23f213057f60be7f8bebe29769d8c9d2c0a23d78ca5a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b632f3612f874b49853951c96565ec37ba033d87626a5f0c5aac279edc53fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a30297101f875ab52f81eee9ce85536770ba5b878d677514480d2bf45210e798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f8b4facfcf8b1c28db08e7b89f6016d0882ed071b887c667c015b7cf3ddd0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end