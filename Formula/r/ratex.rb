class Ratex < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/ratex"
  url "https://ghfast.top/https://github.com/leoliu0/ratex/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "469fb82b5aeb24cba427eee292315141565aab40178353a2b0802fb40c25504d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/ratex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5324c2c6e91c6614edb79ac0b2fa841cfbf964daac0a1c7cbc4ce68d57cddb1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6a9fb6e812879d133552c166d3ac8b8d1cb33c932a5ec35711159602ed25241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f889888c6aa7fe5ba43a7e28008255ed987489c6f9e4711d850600aa258a63a"
    sha256 cellar: :any,                 arm64_linux:       "20a483a655d99afafe5a7912f3072d84e8388be41aa136f42c994d26068340dd"
    sha256 cellar: :any,                 x86_64_linux:      "7bba987482b9c7c2600cad96e1ec2581f2882f06325bac745983921cb1e3dd91"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # TODO: Remove these settings once a release includes upstream's embedded-archive memory fix.
    # https://github.com/leoliu0/ratex/issues/16
    ENV.deparallelize
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "false"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

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