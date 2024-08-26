class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.26.3.tar.gz"
  sha256 "3df07ca307b77c9def8d6afc32bc96bd5516398042d54bc095560c1b49a38089"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f2746e3d099e6c9effa513627ceb1978470a346b48f3d9412bc0ac4bffe3d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71f18646cb204896abdc4afd578c23dc23ced13ab3cb597ba4afc1bc3b03a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb836b4e084fcf6e2989686d1ebb985b29d523c1bd29463ff4809f2d8eade7af"
    sha256 cellar: :any_skip_relocation, sonoma:         "531d5380f9bc30ba648990c1967cf85c48fbb3923d8de083a9c2460bb906e60b"
    sha256 cellar: :any_skip_relocation, ventura:        "3892b5e9083326a295be3f02c2c948bc52f14bfc34e276f550b3bccac4d95228"
    sha256 cellar: :any_skip_relocation, monterey:       "f37ffa0ae8a96ee14e8dfaaeffe7b89e35878ac2cc251a1453899b17c2e9b0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a31134a85e4012b08e278e96760819d917ca6862f1059cc59c9b20e193d72c36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end