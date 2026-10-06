class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://ghfast.top/https://github.com/leoliu0/texres/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a048ccee034a2c9f269a3eeb4008a8b1f79a4c7f9126612e002ef9275234f0a2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7330f86f2feb1777af2a0cae5b777ac698b35b5e60d0e593f25a6cb206ac1785"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39f79d14c7a3bd03d138e5bdf5ffdde5d47395719ef315eabf3348f3503250cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01f0e901a6023f81099d5cae34c246b7860f14a835003b2a9fa5fa1d6879bc55"
    sha256 cellar: :any,                 arm64_linux:       "180d47b7238ccee087cf522ab491a191ffd645df87ee629c3cde51bdd4a21f79"
    sha256 cellar: :any,                 x86_64_linux:      "b259fc4e5c8f96baede75144a9d2e1ec1bda4c8a0063cdf23de47d7df65b06c5"
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