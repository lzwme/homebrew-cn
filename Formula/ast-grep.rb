class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.7.1.tar.gz"
  sha256 "51f48bb0ddb0b1dd56505ec0a3b548927f0b617748507131f6c447b6d554a7d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a232c31d9b04545ac998ed7a5410a1fec30842ce2d4ca1573606574c0e9278c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e9a6782465ffd92b3a30339803dde462fecc58d01004a88bc37365edf892b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "441121410fee6a8dd0def19e34228aafdbed86dc0e8d151a00f3bc76a743f65d"
    sha256 cellar: :any_skip_relocation, ventura:        "d311da012020dc5ef4579a00a6b26bc24ce74a6a3dcd6fdb9c05b47e0c81b5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "0fd9899ee6c3e505385eef45530f401882e202e1c02962afc4813d6b53eb9b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "84933eb0d167df610c19e7055858d8038aaa8111f999730bdf873ce79a1b2026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc8f8eecedcdd33055f3b44e19196289efce30617d77b55dc08ceb04bbd5041"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end