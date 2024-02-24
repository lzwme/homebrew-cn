class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.19.2.tar.gz"
  sha256 "6b12d5641eb3c5b282aa4f56018fbea991256e9cb2c221368394bb3209d2257f"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1af5bfcd737d737e4c8cca1727dff0562f9356741e54d38a16db873dd30d4ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efc22ba6e134ec98cb90cbe400ae5e5ce2dcdbf1693d8964929edac20a917133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1e6fcf06695c600bf06de72b1ebb39f51274efae746dceb1f7b48dd9b3e389"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac649aebf370725e813649efa1504db4d1b0136ac2250909e653fc4d90b9e068"
    sha256 cellar: :any_skip_relocation, ventura:        "81192222c9fdc52ae3b2ffc65a169635f8089f16740d74f70aca23439cac1d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "513be354f10e75bd2ace3349d3bafffa36c46f52d91261740dc0f0feffcad773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27ae908a8ccdc89f78fb534cae13884d71ddacf39bdbc995c1f6bde0bb20a7b"
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