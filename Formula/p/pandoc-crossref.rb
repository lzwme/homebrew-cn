class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0.tar.gz"
  sha256 "a1933b7aba27ef352b7624d234980dc4c4b46ebb607e940c669c2a187e6c6426"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "294aeda407aad5efba1f8c7475b6cd76225e9b31884cd8f6448b0df63c46925a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29f63862c399d89fc702309d912cc91b51b1c46d407af41e9c2a52d07fa78c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35063e0f48b8aed08bbdaab5092686ee300e40ea6f1c2517ffc3ffbeb104869"
    sha256 cellar: :any_skip_relocation, sonoma:         "f03ad18c445e86fe22fe160d4ded8c62815512093e0e4417ff8b065b4eccaa99"
    sha256 cellar: :any_skip_relocation, ventura:        "e1905026f2dc5b4e8b63c27d60cd676e38573745b23b0661ff33ee68981b832f"
    sha256 cellar: :any_skip_relocation, monterey:       "1713b6f5af7047fb6b073dcaa296af5c6cd8edced898d34a6d3ae56a21670a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216973528ce18580bb0f2987a90e6b1b725cd7d83f61203915426e658d0e79be"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end