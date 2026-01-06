class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.4.tar.gz"
  sha256 "a0402d5200437cb506d5176470bcd035497f152c292c5f7c93c6e70029531357"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7085dd067a84b20666128d9afda124af470ab150844cba16b9d5ce83e848b9b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e567da7bfe06398e9e2e6a4320798b163a557660ef9b835f2fff404ccf000a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7f3f73f56c4f005d1a91809f9f69f16d24ccb217767a4067f704829d5d623a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ca0d80841744e7753ee25e12fd3caddb4b540f45b4b53200e472d6bd95f15bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfbe5d3a268d289ea783a2dca01a239b5df3cc13ae6adb888735dca7b7596c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb1f2debc378e6cc8ce8e3609c03e843f07132d346f83640bedf5de5d73328a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end