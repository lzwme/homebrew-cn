class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.1.tar.gz"
  sha256 "b556b38fec358216fb1cdf1cb4825e689176c7c50caad45be19755dafbdf3f55"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e276682d8f2ef2d3ba0728bc7a78d5354f53868c6c366774e3deececef77c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9facfe9c825d6dca00c3c813721e346437e5b2b4bc70cb844ccbcf6c7ca33c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ce0f6c76ef3c2118f6772a40141132660b006c681ac1b61e707763d45a6f3fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0378d4aac1c37af738e760701c6757eb5839af112633794cb8da3fb9630204ec"
    sha256 cellar: :any_skip_relocation, ventura:       "19abdc6a52d5bcd471bd85c70b8275533914d717b6a3a0eaccf8bd54a0c75697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa55519aaee5f8be044003fbd136af69e1a9cfd96b8a1a42a7e97af1496ddc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9090b0b1330047cee30e98bb8558c602e8d7006df2897091a3560f2e46882a5"
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