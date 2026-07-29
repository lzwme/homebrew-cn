class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "cb42b8319a59f258fea191e4660b62bdd9a90a9099322ae0f17203bc5986498a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6273630e628147c3867825c59f4d1701420a0f5dcba722d58a7dfada3ee66269"
    sha256 cellar: :any, arm64_sequoia: "ab6ad052f45b7af74ba24e73fb1f9159b82680f4c4345ef241e19cfd212feaca"
    sha256 cellar: :any, arm64_sonoma:  "df653d4a9ccc9cb723160d751a3672cebcd4838d80abd0756185743ff4fafab3"
    sha256 cellar: :any, sonoma:        "f507e4c2192c863cafd1a0a6ff0440580ac1d210d349006a91eb9f4419be849e"
    sha256 cellar: :any, arm64_linux:   "e7cbb5f4519594cae33210e71732b3141e8465b2612fb38409353c5ef25df6d4"
    sha256 cellar: :any, x86_64_linux:  "b6037d6ad7acde6b0af51636af2ccac7ee5d8f8d366f6e96347046852f8faee8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end