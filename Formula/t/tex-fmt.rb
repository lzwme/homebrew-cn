class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:github.comWGUNDERWOODtex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.5.1.tar.gz"
  sha256 "60c74c8f0155d1324e10c4e97c774bd0dd4449cbdd703b704d791a3c0f0b0364"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca1508079191377c44231ef1aff3150e00dbd0100e35df91ddfd5481cd4b669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cbd11af828ec9c23a1431138f0e964e6576f0afa081b8b07e8a36dd3ef8ab2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee6a729c75f6cf03117ed8b5f1d3a30eb8a392b9eb5b2db16692d10240a5eeac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34164bc0c65f0791dbd95f81c6f0a547ed2c9f26ca310875a7fc59de325ab1f"
    sha256 cellar: :any_skip_relocation, ventura:       "193287b0b307c8764387724a990edc046fefddc394d3b19558fc459b89b31d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7f0ddbe932b399ae82059ff500444e382394c42815dbf77d658a1082e6dd43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"tex-fmt", "--completion")
    man1.install "mantex-fmt.1"
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