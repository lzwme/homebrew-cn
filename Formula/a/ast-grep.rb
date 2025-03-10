class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.36.0.tar.gz"
  sha256 "aa8c1199d191859d61f4b407ad8ad34aa46a5a57575110b6605a1bf74f7f2363"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc499e3d774e8fdabfa6167e05423ca05081c9c72098af2bcc2fbb5038f0ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c904269697f38365985b4e70b8b6699112a817c48eeda55892c399010efe26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b08c7b8f128eae34fd696529911a24be248236e90882e3a6da64917ba44210e"
    sha256 cellar: :any_skip_relocation, sonoma:        "24b59e7cf3d612ee05bc8a2ef0c06d427288690e11082d446d9bb83cf2b1e448"
    sha256 cellar: :any_skip_relocation, ventura:       "830ea5dc261697a9c094bcc113cd688ae7649cfe0fc889e6afc2b519526b5832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424a5578df720bede27a7b8334ba0ccf084755be1bec1e8dc438587868d575a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end