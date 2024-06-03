class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.22.5.tar.gz"
  sha256 "7e0eda7879a045277faf524e0d8f37905e9c05e2b2013893809e136378a24e9c"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f899361b5f10b5ef6010356b537831e4e0c84660b0c010c59b2fb5d4ddbf401d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48a16a0830b7e766ea617aa37d3ddd950f9129bdd11d9e3a52634a7140fa18f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e21f3edef4cfc94295e06be1aa1e6313e892009f4455a62315856d97032241"
    sha256 cellar: :any_skip_relocation, sonoma:         "5773fc1b4428c0b2b93b089df15693bdc29ddd06d0f840aecbe5c7431426c6d8"
    sha256 cellar: :any_skip_relocation, ventura:        "e02c2d4746aaec662eb91074c666c410040932c244583ea21203462638f317f9"
    sha256 cellar: :any_skip_relocation, monterey:       "64951c2878591ce5a68a5f038ce44ff750d7a997c79d153041d90966811e7ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c579918528f97f7c1d56a7e80e77f0abf2ffe5b3e138fc8a13cc41e9e37d1fb4"
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