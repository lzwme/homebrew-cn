class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.7.tar.gz"
  sha256 "498e7837e5e58ad14f002001b8a43c41819035b688a10aade41529933b51967a"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "320bef4c63e24da69e20f6122feafc3f17fafdf7711c53ff7e27ac9a3f1d3f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922743afb2591f644d16d00c58145c38d3aab4aff69a972737b355a68ab7eafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a7fd2baa7ee183b0c4c59c43593909b395b918c025091d488b5cc61a15c7eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff4b844e955ed00e6e3d1f7350173fbc492daea1b657d27c3ca97614a2db777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31916c0819aed130af72cdd6ee8c820d8ebfaed64f699d7960714f2634ad629a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efce3500efa86fa1223a859f73cd760485d8541fe1cbb66be58c5a018faa443"
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