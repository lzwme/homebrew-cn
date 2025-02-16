class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.35.0.tar.gz"
  sha256 "bc143bef9bbec56c5fd85cc1936e0bc4215c71b0f4a9013b2aa86b2280352875"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2fa2885945a9bb7afc3527b5e071c9054269c66d0bb75ecdc83917ecc802fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e501e74fdcbd525512543da393644ec7162707de7c403891ba2e193719ed1887"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4792575b1932dd6848eac8c51eb2f17e9a0adcc25d0e6d5229972662e7a96c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b54b7e27bdfb1b33a99df4161fc919f2aed11cd5a7d405dd48095b6c92e8ed"
    sha256 cellar: :any_skip_relocation, ventura:       "93e0b24137db995c82e993ecc48bb5bae8daf902a881b9cb0d8e7b31d19e2be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1245c9a794dd10167016c676be6356152656d1e15dd1d77e2a9f86946cb66e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end