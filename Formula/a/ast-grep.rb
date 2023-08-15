class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.11.0.tar.gz"
  sha256 "9b8e634efc3820829c2997d8d22e080aa97629c4e52f94db00a7175ad90163d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60507b13b6e37ffd2c00e1efb375c5841443e20e45b851eac0dfca659dbed073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9ec7008f359874a3e4ac0741b07e4fd38839e00982bae2255e830ef209f193"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f433aa4e917a6f6cefc5f494376c05f120eb3e4c19b6d47ee7847b120492eca3"
    sha256 cellar: :any_skip_relocation, ventura:        "1170662266a8ac26d6bc4c86f5c92d883ca8e946d790b9df201a08a369e695b1"
    sha256 cellar: :any_skip_relocation, monterey:       "560b485b7659cb10edfb8bba1dcfe56e6f9bb73cc0673c135249846912836a39"
    sha256 cellar: :any_skip_relocation, big_sur:        "26f5ac8ae5809c168509aae7135115da942e5da611652473c0a95a291fc63055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08c5c9baebcce11312bb0008fad542839256cf0eaa4ed4139738455f51e9bc33"
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