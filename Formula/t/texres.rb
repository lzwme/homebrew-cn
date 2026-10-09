class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://ghfast.top/https://github.com/leoliu0/texres/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "431e5a0293470dc68e8b7cb5af15351a7a9222f62c60732026fd7c625cf563e6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91b0565b3175c3e66dc2cc8003cda940d3909664f4ead73eaa82e7595c37dfb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e47d9f6a42aa1376af65bf28397bc2fd433c21a1346808b361b382ce82d174a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3145bd3cb625f74fc857366c9ca1006fc9210b1d03ad641bbaa0e1d8552c6903"
    sha256 cellar: :any,                 arm64_linux:       "a70f75e9a5e1e0eba64b0d45d5221bc890f21ab47024c7bbcf6498762e573936"
    sha256 cellar: :any,                 x86_64_linux:      "64223b8ec90b4c05cff2620eeecc55c191bdaa5c6815f3a618e0c93f7386e18e"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "texres", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex ratex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "texres" => cmd }
  end

  test do
    (testpath/"sample.tex").write <<~'LATEX'
      \documentclass{article}

      \title{Test}
      \author{Homebrew}
      \date{\today}

      \begin{document}
        \maketitle

        \section{Example!}

        This is simple \LaTeX file.

      \end{document}
    LATEX

    system bin/"texres", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end