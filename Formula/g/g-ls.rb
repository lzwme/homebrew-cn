class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https:g.equationzhao.space"
  url "https:github.comEquationzhaogarchiverefstagsv0.29.2.tar.gz"
  sha256 "061a939523b79c60c98993e9d2dbe46da529112cbfe20ec9e0e8778a65eb05c4"
  license "MIT"
  head "https:github.comEquationzhaog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ee7558957de48fe5cf5778d8dde8f9e1f9166d14315c1cb2f604ddf85ab7a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c1b0966690decd1b3b7d1c2878d0077b300469889fde8bcaa087cc9519fae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d47a2317ee3fa8164b58e368d8678be53abf32e6e7d73c56b11387520bc57ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a919a43bb65b29768c6de8e518a07e064e9a8b158aad61e0b588aef699be4635"
    sha256 cellar: :any_skip_relocation, ventura:       "c44b1529773a09cec1e3ce8c82b3f50aa004a64764d5ec02f92b6706e36bea53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5698244f02ef325348fe5478d29baf01156dcd8219dbeb10bdc7222ab8d67785"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"g", ldflags: "-s -w")

    bash_completion.install "completionsbashg-completion.bash" => "g"
    fish_completion.install "completionsfishg.fish"
    zsh_completion.install "completionszsh_g"
    man1.install buildpath.glob("man*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}g --no-config --hyperlink=never --color=never --no-icon .")
  end
end