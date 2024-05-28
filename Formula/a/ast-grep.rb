class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.22.4.tar.gz"
  sha256 "d4679b11b49863f424d520a6289a7f9f9cd7c876613a003004f426af23ca9c95"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afe2b65715cdd510ed1db764e476d81ce2f3da6450ff827eef7f5a2ac44e35a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af73d83221801d3c3ee6764afa75586c100aae1a31be326588d3f8f9e1022de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa28d8a6eb5f99a24a105bb0f51a6bd6228fe331ed3b088aab552f2ab5b3b27d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3fba9041749e05eba5bc61b87ee9769534591dfc8850235e518611aca8d1693"
    sha256 cellar: :any_skip_relocation, ventura:        "dac5928608c12e11c3301ee513862196d7fba696acaea981421d983512da3cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "58bba563bf0b49ac2533deaae6d6a87633abec2b7cecc374a94ea40413669606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd19ee81ee0d80d7a1337fa032dfb33c3f89e461477035401012cadc655dd16b"
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