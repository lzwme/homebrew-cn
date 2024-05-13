class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.22.2.tar.gz"
  sha256 "46634d945fe4492a61a912d021f65fa447639642a70ef32784b56de4b83b1dbf"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c0a7d8507805755d8031e29fe795a2e3be61060a2617cd3ab75c818411b74f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b0bf18cee4c3c45ef7912e66985baeb189285f7daf14f2e7189f221eeaa0834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "975ffbf184a02982c15581360aac2bf43435f06ebeadd767a0ac65f773857c0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "be3c38f88579820d34ab2ed92270161cf3a3741f264c21f2cbf23db0681955f2"
    sha256 cellar: :any_skip_relocation, ventura:        "abc459e02473dcbdca629231f76f7d6b41a63a4c879c4c75ec415e42652a582d"
    sha256 cellar: :any_skip_relocation, monterey:       "b20fe8794feeef92195cca03a2a081697f71bcff75b384286b4062a9c5b9e041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cfaaa01f18ed82f5ff36c6aa1d9da4f1bd0289070981767043d0d34ddd9eaba"
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