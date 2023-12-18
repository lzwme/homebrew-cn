class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.0.tar.gz"
  sha256 "a1933b7aba27ef352b7624d234980dc4c4b46ebb607e940c669c2a187e6c6426"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96a88920db01d3d497f717dea157cd0b3d95c9dbcd86b58ef939884e0f9551f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9129216c2ad1ea5625b435d154792e22aacdb7440ca1dd33a0b249ab4ec07f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bce44eb3b18b8c7584494668bb62490f14ae9ea360c7b4f86e9f8ad43dedd5c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f140f3f8dc4d4e3485f5154af3b73d432f88f92a0e17d9eda11572fb5e0d5b8"
    sha256 cellar: :any_skip_relocation, ventura:        "58d5a8f3f8fb302c71bd89f2fd8472ce0abc5d9a09ad6fa8e7fc3124079a9298"
    sha256 cellar: :any_skip_relocation, monterey:       "6a53abd55cdf9cb869d82bab0f150d5446cf392a8eb60909fac24990bff49bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df8b58df089e28c03d91944e448a1c571a103d1d6418d2d65bb1a09fbc0b99b"
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
    (testpath"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}pandoc -F #{bin}pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end