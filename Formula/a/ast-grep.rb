class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.7.tar.gz"
  sha256 "c12c062564d98d7fe386832a34ed81116e1efde96d92e6edbaa893bffe3817f9"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b34445a3ce91f875c3af72bea28b4e8fe7dc3c2a6a6885d081b8e6101519058a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1867f949ec877f80fd68c9b8aed7c355e74a874f165e25fa1a00ba955acb13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb4c2c83731f469c98ee2a4bf576c03faeb755248e7e3e704f9685f67ff8261"
    sha256 cellar: :any_skip_relocation, sonoma:         "af8aba6b796426f673e392ef700f55bbf2e3b238003d97afc8998513e0097ea8"
    sha256 cellar: :any_skip_relocation, ventura:        "dd133dee16ffa33825fef13c2613985d9a31cea2a4a30035f1e0cf863753f098"
    sha256 cellar: :any_skip_relocation, monterey:       "ee8b726dd988daeaf74447e94c5a802c9724afc57d88942be21810cfd4623e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b72aafccf5bccf52e732f3a5cc8cc75f5e8deb7725733bc92a3a0d84a1de11"
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