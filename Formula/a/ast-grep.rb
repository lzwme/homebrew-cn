class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.4.tar.gz"
  sha256 "6a8665ce5105920fdff5e972e37ffc3cba7b0fe6f3eff9bb05fa06ce778e077d"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f38bf941541fc6009b9f42b7e171c8e7dbf2140cfc9bea3c22649f249733c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdeb3de74dddc3d0b6bf61f8438c450f95682f33044447ecd5e342487f421b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd7f3c616c3f706016f45f25405d5299685c73995c8c8565a8557f789c523011"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc8ddc210a24ed4f7e4846e2ebef5a08eb9fcf2261f87c154bd7f4d2c350119"
    sha256 cellar: :any_skip_relocation, ventura:       "149364353b3ad09c9834ae69e29bfff20b8772e24087611d993065edc98a2a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d293889cdc172b33d0041c5f71b93a7d078a854eebb614973c0045e92c74ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b89000cdcf2d51519df855c4469cebb4f0c87155d11600a0053d37876babe040"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end