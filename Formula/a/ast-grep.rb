class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.19.1.tar.gz"
  sha256 "22b8397895d65f738126e7cbf73e0c95bed8d36f1c3ca09b21c191d354c50a69"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdcdb4a6adb2ab9618245b97ec2984f2c480fcd1f818d6b6ac2bd248f7c6a943"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5538de6bb948ddcf7849587bc4ae787ab0dbd014986d0d0de626356014d4f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b5ca0080c171b1751aeb4f8f4f168316405d783c22b26742d80262eb080b17"
    sha256 cellar: :any_skip_relocation, sonoma:         "db5cccec017b59923186f3b3e24113e28eca3fadbcec8aacecb1fb81c9633f77"
    sha256 cellar: :any_skip_relocation, ventura:        "956891d387b582d65fea407ab8e2ca9ca093f8492e769dd1ba26771627e1e903"
    sha256 cellar: :any_skip_relocation, monterey:       "acbb44f6e195b6f0918b6b660a9cc431b3382296a0d8536471bfe386bfeff713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476e522374867fb2d7910dc1d0fe792ec720d617cd10821a6c37615ca161680b"
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