class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://ghfast.top/https://github.com/leoliu0/ratex/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "03f60467885ab3bc047044edc16511fd5cf5735fc4ed26be5c662def4954ebfd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93cfb646f709ccf95b9665e3f2343d4c1936b61a05c48a61cb6f2bc21b838c5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fa22588fc1316b50e6a062f4a4d097c87760234713b71dcfa47f7355332498b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edcfb6fd67241eb211a1a3f2dc6d697dbb3bd85dccbeba75eeda4bf2909b8284"
    sha256 cellar: :any,                 arm64_linux:       "df23caa0e0c37a757adfeb5033ba9b7af5cec6720bc00e42a683f785ba2e6516"
    sha256 cellar: :any,                 x86_64_linux:      "2ec1c3d8818a25bc20ab3a963ccf5316bd0eae0328f2e16d35d39007cb8a32b1"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Every bin embeds the package archive, so linking them all OOMs; `ratex` dispatches aliases by name.
    system "cargo", "install", "--bin", "ratex", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "ratex" => cmd }
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

    system bin/"ratex", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end