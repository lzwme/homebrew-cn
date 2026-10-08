class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://ghfast.top/https://github.com/leoliu0/texres/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "876aead94987d03d70d8bb554f41ae26ff77201a93f6170755daff23318f5903"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "500ebe3baecfd8cd3db760341d380c39c3f312ba25bbbdb5fd497a109631bb48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11530bc1cd5494bc246ca60b7010e59df4c65ac7125f57e62bae3f9ec58fc20a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ed23f62599bb7154c1bff5fbb2bb0d0b866daeb83dbaa8ef619db1a2f042e44"
    sha256 cellar: :any,                 arm64_linux:       "54f51a062914877907be9f478cef3366adb60235b00ffa5c97702b42d3143cc7"
    sha256 cellar: :any,                 x86_64_linux:      "6d5529cb9829541f3529aa5579e5ff722d10051c60edd7211166cda3aef39f4b"
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