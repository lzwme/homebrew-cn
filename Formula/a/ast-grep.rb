class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.6.tar.gz"
  sha256 "dad6d5984f84f96b9d999c8491cb14b873cc90c297abbb7c9391b8e11f1a794f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b445b83d563e8f9b239e549dbe0e954ec07724dde584a0cf2e0d7afa52edff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adece7f8090de31a6b269ece7f2166e3880fd2ba476bc45d28e30ae5107f0512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52270bc0a21369b08d99b3a0353da90fa012d6f5b1993f699a6f44b90b69ad95"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d5ef762b636119753c9f4011ad28f0a225490df745f733e5b4073dacb8151c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "358adf0007e248ec8521a724f630cf7371418366d2328e801320bb617a6b88db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bb111d4cd64819294c2564c0cc0654d2c6a9d8ba4836fef14497fd4c734e925"
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