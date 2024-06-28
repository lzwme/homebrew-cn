class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.24.1.tar.gz"
  sha256 "51c4c8823de87f8069e122500c185c51b97828a98ce01e7a3a16949e9c676eae"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab242c1ab56e3a63c85d59548b324f16c321a38f809ded41661defff10be4ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af77ec5a408294cbbc2159abacbe0027376430bc77228bf40fe7310ef3b5ef15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11647bae37279e0fbf4f194a130a1e6cdc2f2fde8c0e07d221cf661579405de5"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca90f7fea3c2c3b9538e851737e81b78fe46e628a5c3a795af1723b49e8f173"
    sha256 cellar: :any_skip_relocation, ventura:        "ed678224a9cc5ebeb772294b32def10df51d7914ea329ba55dc9095cdee03a57"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6c20db38955834f071615c809fc8bbf04a91c92470e45e4bb8dda74e9a2823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e09d490917ecdfc515e15dd54416956b5d4b7fc74df2d4f9224d432bd63c848"
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