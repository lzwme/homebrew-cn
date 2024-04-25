class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.21.0.tar.gz"
  sha256 "ef8c33b77cc7c094d1a7780214726f6c3b8d0d93e6d6503bd8d0f6d4371a3363"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dacb1ee93030ad6dec956ffc58327545846a439276acaca48e62388b46579da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5035ce553bef09337e04f9f802f324af9762f491c4130ffa3ccd80f17cc73c88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fcf03b8eb1db3e5b110de1d875db35112d11cae3bb3479d265331047cba4406"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf6e62e00b1188e674d3c1690b402efac7b164ef3051e2c602b24368b61e58e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f8961c57b5ced8c13f4c09fc93e703d4473bf4156265b92ce801bb2c52fe2df1"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e7eed6fbe5bb4f8bb25aee546017580161fd677e50951d583c10b4cf9d93dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a2b79657633ae545129dbb50a04774bf88131fb37f5e332a0b673804825a36"
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