class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:github.comWGUNDERWOODtex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.4.7.tar.gz"
  sha256 "3259a5ee9211753787e894c10313541108149285e7eba27f8281886bb14b5c79"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0636bf40ec68b03b914d0dd4115a8230f6ffd1d3b6495cb19ce3dc304ca9ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5afc92da72d274f39bd1684150acea5a6000ad632b1234605cda190b5cff7a43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cf0767c4734a75ce5372f7cda16960d9ed983d9a34c33d1812fc41ada68424c"
    sha256 cellar: :any_skip_relocation, sonoma:        "236d4385a0656b16fe0fcb2e0ba8f6dec2833c89554c2e00a692a76d93b03965"
    sha256 cellar: :any_skip_relocation, ventura:       "c8e1949a1da55a773b52cb1bd0d7454a9a09147c668438f12ff1e70c485a72b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9064b7e146abadfcff4001160ec5b4fb2c97a83d18007fa2afc0b07bc341afa7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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