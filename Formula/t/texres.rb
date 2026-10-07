class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://ghfast.top/https://github.com/leoliu0/texres/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "fedf84d0c3cc35a8010b6cb753172d2139abe0de5c22c9374596c5ce736adb9e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "673e98693eba51afb1719c1e24c5ca13906268e61b0c8837b8ac7a4f5f45f675"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc7d7598bed47a82ef8390ca5cd8384fa63247f220797cd9e934223767e99206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cc94292c496628018994a6111ac1484b080b129361c8f6bd5af0e548a597586"
    sha256 cellar: :any,                 arm64_linux:       "02a42afee70008623280a1dbf3c3466837977c4185fb3b6f4a72ba94f92d72b3"
    sha256 cellar: :any,                 x86_64_linux:      "e0c735d62b50bcbee9e89cb73d4c42a4029995ab201db785f9c5f86b8053ab71"
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