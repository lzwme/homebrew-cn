class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.38.6.tar.gz"
  sha256 "57191fc73ffff106edbd5bd47762042227c3544d08f31e033a4b93cdc08f4844"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65c157159c6bf541c221e0e920099730bb3a68c38f3f6dd29f4e3a38c7cd165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3a5fad5ac7fa70bbcefacab092d5538c7bee88e094f4d3131716e43d6c43d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1aa8ba85ace51ae5fafeac2d17daf40c2086c486cac36a6c225362d448d8d063"
    sha256 cellar: :any_skip_relocation, sonoma:        "beef128ac40f0869f1230d6355601472c63dc57ed874000efa613400b6d97d76"
    sha256 cellar: :any_skip_relocation, ventura:       "efeb1daed52daa046c95e457e5dab4369abd452c6bdcee6cccf7d493277cb90b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72312bb8abca1afef1635d5c0556d6b5b2061ae9056d5cf3563c4155f99b31da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c12bde4ecd19152ed8344ba937436ddf7ad0a572ebe0eeb21e703ef405707e"
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