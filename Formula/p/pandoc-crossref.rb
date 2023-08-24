class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0e.tar.gz"
  version "0.3.16.0e"
  sha256 "7a3101189660358fa5738717464fd49da3197ccb1417ef9f2d90e50fab75e3c3"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84c01be42f81d4aaf087d41fe41a173867deb2e9beea1eab438ce57eeb4e7690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e416a12404f2ba4ab14f23d998628c81118ea7a3955721dbc3f6ddcd33713c2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ea983d1fcb6c82ba49d017062de8addc4504cee45bf6477ab21acc07f80e6fe"
    sha256 cellar: :any_skip_relocation, ventura:        "540cb87ebd0f3aa212dacbf55a02c2b4b3319ea52183a5a6b5fa4b20ecc2539f"
    sha256 cellar: :any_skip_relocation, monterey:       "bad5f1706f0806f34a835f3e543cf8ff666ca6874df0c4abb92b0fb7471551c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3eb5a1528841712643d8bc2c40db0826974a719d007fd8ebc5cef13ae377966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020b55469dff823ad29f4bef563065ce3fa176e57782bd88cae1bf0900563505"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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