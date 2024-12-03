class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.31.0.tar.gz"
  sha256 "a1b465dcba420b6b150fa2a8d5f6322cfc583096ebcd7a028390ce60e9d41720"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd40e7c1fb660df4450b2568fdc8b1903871e55b9d9228394dbc1caecb81e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21021bc99f67c9e499792eb23eb90c452a4ac6878121da3d738ee9926c891efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1d7482320b399d9bef44c35af1d7a79d7c8f76e6ba49760ea20a00ddb4c1cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b256e0a58dccf3e6bb84847cb5a9d6a9e00c6865f4487d0c741f4f99e88eed6"
    sha256 cellar: :any_skip_relocation, ventura:       "a129a841e0a763ef569c5103bab89ae5065e1ab808a9793bb86803003a9b127e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5521452b4adaf63d174aba386556f3b4f12b462572bd556fb08ffc4d25c57322"
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