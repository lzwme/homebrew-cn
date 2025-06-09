class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.38.5.tar.gz"
  sha256 "c02d534ca2ae22874675ce72ed694600059b68396e636ec653f19a581bd7972b"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6434f44d17d28b9297bdf4876ca376edf589424b62f9f7d0f8087983abbab0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88f76581f66c890a668fc81613a5d37bc9b10e53a0baad14bb63f4fa1034d003"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73be84f618f3960773a4b077e1198c636915f1ca9271bcdc4742771109d462a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc2718439a572d417b91aa2686e728b0769a964ea4f3077f5b81edca9fdb5bb7"
    sha256 cellar: :any_skip_relocation, ventura:       "7dca9ed92fd33c602c42272530927ff9833d2531234841b2cb4d945f51375f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c83ea03f79b1e4b49549c1593fdd473a5fadc53b81aecef9fb74c7cb932336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37fd4f850ea02e9fd707ebde85c75ad9360f6c44ecf053a542bca49f40bffe66"
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