class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https:wgunderwood.github.iotex-fmt"
  url "https:github.comWGUNDERWOODtex-fmtarchiverefstagsv0.5.3.tar.gz"
  sha256 "39a7cfc857a6babced169ce3b61fe506346fdc938165aa836ecb570421634ed2"
  license "MIT"
  head "https:github.comWGUNDERWOODtex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbaa02d7b62327df5848274f947ef0952f746cb76d259214d6b9e0190814c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5d65f215855aa0df3303ce5c860ece16260befc7e4e2d499c593ce6e736964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73943a87abd2691d01d0da3ea256ce6b3b0d528a72aee2f1d96b1462b08bb54d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d15e5b078bcd417f4a5b84d4da2a58ca3164fda2dc079456f467d3b276934c1"
    sha256 cellar: :any_skip_relocation, ventura:       "b08e09f11d43bd9ca9f820cecee2250608c37e824f4ed14ec60af457844af837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379ad740d3941bddb04c6ae16375c0b509612fe899f7041a40bccf17095d9cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c0682fb9004c869ade569ca727f374e562e78ab5f076b4f0ad00d378778817"
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