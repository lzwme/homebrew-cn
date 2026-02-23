class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.41.0.tar.gz"
  sha256 "0fd7cc46ea74b2d93fcf733fd1842796ea1f2d1d35c0f2f98a20de5d1a21f629"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d1a0e8ccb265e479e570ad3b96fd13884d8e8b638c6e61134f7c0726980b4f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc3df9c918b7334af4c857040ed1ff5e9fef47ee7ceb761d2364b080b2b69d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c76e7b3745aba46231983d471480ec3bad29253e43a01ded05bc163f2483acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2af13dbc8453ae79a1df9bae687fa291b4fcfe3402c5aa6595fbde5fa355037c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8403b053fabd8a7f1e7f5289340eb79258b34301181c46e8b480ba81f99a3acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45951eb841f5d001a818517f99abba64027cac1d863a12a403167d3a0b354c73"
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