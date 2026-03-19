class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.23a.tar.gz"
  version "0.3.23a"
  sha256 "7b3638c8b8d416f28e950cf650c52d3e961f53ce6cc640133caf8ee99b2efade"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1199720902a309efd2eaf2038d519ad0dc387a94d08391720c759787128e637e"
    sha256 cellar: :any,                 arm64_sequoia: "0b0ddae7dcf8a458dafee78d14840a62fccaf059ec0d1f86ef43ade74ea1ee0c"
    sha256 cellar: :any,                 arm64_sonoma:  "15315d3a031dc6e557562d07230e9499633f60882473e935b457cd69d8d7daef"
    sha256 cellar: :any,                 sonoma:        "2824ec4e3bb1257632fe0227b25085fa8a0139335adf3464fdcfb40d7b4f5be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e328d095e724be85ba2499dd88a50dc29eee533b1978869643a0d990a45f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71d5f5b8d808c66eb338978934745fca8f6338d4b1f3648c982a569e4c3b836"
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