class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.23.1.tar.gz"
  sha256 "3d71f56ebd96035cb3523c8ee0704bfa1f7f42cfd32c7885bab36a1e6fb891de"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba652886dd83fac38421359a2c7face7d2186ddcebb5bfb274428c7273e502ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74724a2f05d64657bd2941f93517c1722fe2e465ed472e1ea4472cb38cc63917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c61ef37bc43a248112a4986b54850b0a7d3ea9c7f1c2fbc1e907752fe666ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8c5cbfe09a5ccd2b97fe82070638ff93cad3528df8cc3555d4b8be42306688"
    sha256 cellar: :any_skip_relocation, ventura:        "f85610044043932535bc9cc9ab5d6c9937f8942b3ed78e2939a5a36c5cebb567"
    sha256 cellar: :any_skip_relocation, monterey:       "f488544e9af5a7241276d8b6dcf44de7705193fb72bffb8715863ceae150bfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e9358d37a607fcbbe3bf933c8ccfe17a5e081408703678d97a3697c2074c28"
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