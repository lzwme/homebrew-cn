class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.26.1.tar.gz"
  sha256 "729e5b80363265bba19ad96feb530286a23685926d8a9e824c6559db13e7e5cd"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9073f6f6e136cfdc4580e9a294e86241aea49e30c985ed14689463a83fe4661d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ba7a2e719d5db9284ce67a24a163ea0384f96371d6cb74353b52433ab72d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5bd1e57996694ba32b11a7637cc7cba62cc1466d3b3083b8672fc28390e07f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad97f3dd0eaa57c3bbc6f015b034fe9a6c047d6de08a1a86b3c8b925168c9830"
    sha256 cellar: :any_skip_relocation, ventura:        "843b7986f48b5e11df72f148d350325e0a66df47ad33d422a7ad5583a6331681"
    sha256 cellar: :any_skip_relocation, monterey:       "5936b54702ec6fd6696020264c62da4ed07d641c278383ad1962e9a2d61c2b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ed4ec07885053a743b688de59423caa54a73f99f5a27819187d5ebe76f5d0a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end