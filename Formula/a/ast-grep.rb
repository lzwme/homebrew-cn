class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.32.3.tar.gz"
  sha256 "e3d3921294e007a77714df6067ed81937fb280efdc55763d93bfabf308f4c820"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf1737f5ae6e4221a61b2c49025fd830041878fb947ebb96a754f9b67877d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f759e9bf8185d4f3583ee37ceb576bec9a5cbdc138a1d8eed93e71b98a356c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e78afdc7d42d04122f95edadd3c618a58599dd24f717d4d1a2fa00a92e1c8f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "744d96580b01616a021520f029dc9f1f42de215110902bc699e03668c84fccdf"
    sha256 cellar: :any_skip_relocation, ventura:       "9924729dc07e808eb5d08c45fb7eeb11467a925fc71e785719e4f3e2c0ef5776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8802063042aea6d791678c7f8e0f3afd369a2bfaccfd071a149dbcb65e79b11"
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