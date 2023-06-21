class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.6.tar.gz"
  sha256 "af2bb93342190e62fd9279805d42d0fc8938f994cd273080881f14f68aa16fb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de88ba1ae576ca7807306114cd9ef2928387d990f076dae2bd160fe0bc56c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9275bf01fd997d0a4cba3eb12217070ea1b87e55f9cf72eaf4e0b80ca599b4b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68f57c7261c1d7c3b86b9909e1233128f11ff91e632d78e12d39a300f0dd566"
    sha256 cellar: :any_skip_relocation, ventura:        "53f418be5e927cbbfcaa2b373de67c6e50851fada193ae3c2aea4fb395ac7d10"
    sha256 cellar: :any_skip_relocation, monterey:       "c9af1dac16a13cdb65efa017a971e6fa3e54c8e5a1e966b0a30c93e76d0501d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e54fb1af76ffdbaee675fab7c171af8557d2aa423f711752f068d6ffe3a39df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68fe25dc9bdcd104463f2c4f1cc9be8c4abd41b08f276dceedf0b7e43129f74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end