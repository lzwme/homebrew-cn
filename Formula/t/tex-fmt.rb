class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:github.comWGUNDERWOODtex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.5.0.tar.gz"
  sha256 "f7c8444efeaa9ad33914d2d64d92b054854a47ab0a756ed81ca333849892e6da"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45d3d1d7134f2f734c1a8420ca79623e4b56cd6b15ba9f318bd7b0e6656145a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0243c9a251fb99c6dcbde91664b873613a99015e5dbbb49957587bebc59a088a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95cd227cc38e4d0b01e3c1697cf3515e088b50d7bbd9b81b32485e2eacb9ee1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d800eb2556b2de09fcf25670a609e7fac9f6e1e0377d8ad9f3f7300796d4546"
    sha256 cellar: :any_skip_relocation, ventura:       "5c53436c2a1ed16127fabaef44a763d76ba9ed818480c29115a977f76506a2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554e7beb6021f41bc4c08e1674b9a41782e81cda1d0305507c39113006d8e753"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"tex-fmt", "--completion")
  end

  test do
    (testpath"test.tex").write <<~'TEX'
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
      \item Hello
      \item World
      \end{itemize}
      \end{document}
    TEX

    assert_equal <<~'TEX', shell_output("#{bin}tex-fmt --print #{testpath}test.tex")
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
        \item Hello
        \item World
      \end{itemize}
      \end{document}
    TEX

    assert_match version.to_s, shell_output("#{bin}tex-fmt --version")
  end
end