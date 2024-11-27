class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.30.1.tar.gz"
  sha256 "c24654868d99a7e6b2db7ee13e88d46ac5206a0f3cab1bd7cd1d8ce4a274c990"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "947cb3d642116433d8fc721c97461af8185951d5254e8133e7f4a38603cb60a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c4ad36b46f762973ddaeea967e435b81df8aae458075227a3d4a244eb7f737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bdeaa544d60f08fdb1590e202eaf2f343dad871c3a56503b953431df99b13a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e524ae9a10a925ea07c23852e96e928be26053b7e41d34766656190aaabdcde"
    sha256 cellar: :any_skip_relocation, ventura:       "f907d92fecb6c2fa9a3ac731a20d4bb4d104ca9feceef6a8d7de5b7f241fa0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6099596495fb06ac25792a4a342bf3295dab11aff9b963755d31d2dfd629fd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions", base_name: "sg")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end