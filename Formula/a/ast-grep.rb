class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.3.tar.gz"
  sha256 "b6a3a59b6298d30f67bdb195279e66c70615646d1066815e643d9600c6aa3200"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abf07c25a6ebd3c51c55c564b8c0f96e10ad765996905462da95510fcf7cd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41b8be40d9f8d42e8457dae62853b782ac6da1912f53d93977b6b5592d110ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b583ece2ccd1a70615428d10bafd304e47b910df70a6315748ae877e6d9d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d50a3c0af8100fc5aa690e1b542a1277ccda537c57a5a7956607c4f7c60942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36865c62a4d81cf99be5061aada6c4cbb19d83b1e9384c3ec586b13f466498f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a56e6ca2f88183730f616d262b14907ba5ad04d745ad5be68f7cf041334e2e3"
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