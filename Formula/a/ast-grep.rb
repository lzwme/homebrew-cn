class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.34.2.tar.gz"
  sha256 "eaee9bef44df57057fdc46854c7bb390f375f56582e422c57dc3c8573dfe9329"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ddb7371a3706070e6b2252ef27388571d99b90a0e5363617929e2a019603911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5724ae86c09aa85f4ea7f5b4f2d189946434c9362602ca61bf5e251e233418af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f70f275806ba5d21b420c1030a83470d5cbe19d89bdba6bb01dcefb0671ac465"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada38806ed8a3bba064f5a70355b428c0dd9f63ef2f67f558499ec684b43ae13"
    sha256 cellar: :any_skip_relocation, ventura:       "19c951e9d279cba535f5225e6c26239301146982c6b728d3798f91e864e60139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5344f7ae41b2edda11a3721c1d22d8ee66e20bd759951373f13c431bb8622cd3"
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