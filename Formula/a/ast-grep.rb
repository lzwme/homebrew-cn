class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.0.tar.gz"
  sha256 "d738abec2d35e804111874b21d79f3bae8825e9960aa8f88adfe5b58f88d3a20"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "072f24ee2a08fda298a6c91691f7b79af760c54c198f54120172d874fbb0203a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051a23530eda032d7c834cfcf69c01a329d562d4a09dbd62c2d58d48ad538490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7374760968a2f3b30ccc180aca5225aefa44102fc5f6c4c044a9490b4b1ff0ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf5e6d6154615f1e6fa5b3e83dcc244f6b11e1a39f54c81408baff27e735cdc9"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d93ea38a3b40131464a937f528e194eb0c7f35280c9812a3cf0fd8e6fc91ca"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad1b6d4aa2a754fc818fbe04ac3da18673ab46dc3ce4cfb77719b0cdd4d7ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "886c99054f48602073e81b892b8b3ac0f801a18fec43c1f52e7ebc584f467b23"
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