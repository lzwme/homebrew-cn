class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.41.1.tar.gz"
  sha256 "f153b9ebf0d3266f767542e0502c1bb393b13c673823d927292d4f6c193db08f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897ebfaf3e423c66222345cf9bd17469f35b85dd49e12a85fc2f149b2f79f006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8779d447ff5c4f9efc94455e728d117e14184b3b0209582439e0d857bdeacba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c208b67d52858f62c6da80a867930ec0e7f48b22074a1525f7975e4dad3ddedf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dadb3ba6865dc772fee95a4d7ff3f58964aeba3207f2703042b3da14e7bdf83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fabdcd0849fb2c584eadbe4a1befbca910fdf0ce7cbf6ed121ada3d4f85ae0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bc0e9d954b946ce506da044947c79cccf335f9e9f3c373fa3d9d36022607c0"
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