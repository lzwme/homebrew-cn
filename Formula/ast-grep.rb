class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.5.3.tar.gz"
  sha256 "949ea36a2029ba8af37025f06dd1c68d3564550ee442fac13a7243759c5b641e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f6892a6332d0d10ed3918e103e9013b3c25eec506344d4d2888d36bed7f56c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c8e53b9a902d2ad27084efc97bc71ee4a7866e6aaebc99a5f5b5c45b890fa84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "808a5b3d17cf4f78b697ee39cd7d51e9deb329beb16151327582763dcec447e6"
    sha256 cellar: :any_skip_relocation, ventura:        "ebab5d48d589b2199fd67cd7885f6d8359851c687930d83f98a6bd73de4ed01c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e89e1032c66955e7e4e09789dd42ad79f97481a36d6e681ac28dae479a57fc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "881cb724f0da279ce0c20c497c32598b3d931e047782fa878b7411368cf9b620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd23ffc1d682654515fbaafb7acec9714064c32efe5ccb85f5196c24aef0c09a"
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