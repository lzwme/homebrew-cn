class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.13.1.tar.gz"
  sha256 "d568d4fc4f257fcc6d6a99d5a1f4c4638a2d106c653618fa595943fc41452da1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8dbc90829f11b6d5dc47f952c0e8be3a754d7d74d676bbc2783b0d4f51f8772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7de2a53aa3193954616e3ee6eeb706d8a9d3dfe63dd2034eb191b7d2dccc915c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541cd34ad84bf7896fde36b948160ddeb5fcecdaf13d0f28da186e44273d6e63"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6c2ca5da474f5281adf2dcf4b903f1c97484bbc5898423eb176a69d9bdfb4be"
    sha256 cellar: :any_skip_relocation, ventura:        "71d32017b7171140bb95992f79bb516771621403163b861a0159eefa857c37fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2198ab204a6a00e59f8da41614b0250f0b0e5eefeccb862d9b8b0d6ee77080b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280d20d3cce372b4e65647b60dcda40c90aafd47ef93e707856a9efb414e9aab"
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