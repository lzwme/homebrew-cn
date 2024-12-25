class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:github.comWGUNDERWOODtex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.5.0.tar.gz"
  sha256 "f7c8444efeaa9ad33914d2d64d92b054854a47ab0a756ed81ca333849892e6da"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45f919e9777d304f57d735ecdc7217f33775d6a740e9dfaea0938ef735bc649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94379fc8e241a72b95e9111d238683e16ae2d3dea0acba10f70c5275b100d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "710733d6c3d6b26e10691fb7b589bdd450d2994adc388ae9f459974f03fd74b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b642db55484229218e7d31861f74a260af15fe838faa4f7d021e2478d009b06"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d466698f4be950027967f962b017f6ff982e5205c02cdc04c4680fb6a96cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b457542a662e1d33f2e826dd8d67fce5be16ebbf37395291f3c4469b951ceb8"
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