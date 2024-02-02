class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.18.1.tar.gz"
  sha256 "93095e9401eee734cb03499782883bad8cb96e4cde4f0a807fabc79d6c1573ae"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71ab97980597c362cb99811c9bb16da5e2fbc21f3b460e1e7770eceb9088e5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf8e62b0c81804d33e95b632807edb82c679c89dee3c1aa3972d3ac40c1a11b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d558c5184325ae7f5f59d8e5b526c980d38ca06b89f653ec8670483eaa9e42f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4226e0524040968768ee9b20c97d7bebfe23bbf67491edc03fa853cef221d9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "a11837a9830e4f082fc2e4bb6eed1e1561104516f1d367069910789756f43117"
    sha256 cellar: :any_skip_relocation, monterey:       "951b52c25bdb9d846cfc2a762abb84a7abdcc74e684da6bfa5e8704a2808094c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e7727f05ec1018a856b296cad6aebedf4e751f6d054b3a610ad135daf25ee6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end