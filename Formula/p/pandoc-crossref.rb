class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.24a.tar.gz"
  version "0.3.24a"
  sha256 "5b478c94b67d5b972c7b3d867a345be982d3af12475e2261dd9b37fc17e225d1"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "2732ad9d55ecb69163f3725471c2f00339c1d24b5b74b180aff6151640c4c2ba"
    sha256 cellar: :any, arm64_sequoia: "3c70229621f762b729760e4f5bca00a494f93d75407af8ac2b92a816066a512a"
    sha256 cellar: :any, arm64_sonoma:  "d1ba65b191724164adbaf23951cac5533adff959a28c3b1ba91e6010253911bc"
    sha256 cellar: :any, sonoma:        "6fdad65837c4809a0504f444c9217f74326565d4ed5069575fefa77f285bb9a4"
    sha256 cellar: :any, arm64_linux:   "e72d242e0e446cc7347f4430bb6618de3a7d7da074826bee15e63a23967b7786"
    sha256 cellar: :any, x86_64_linux:  "e66d3e9c9c24e8eb457567ac4d8d040275c531dafa961c0f83b371dc9442f561"
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

  # Workaround for pandoc 3.10.
  patch do
    url "https://github.com/lierdakil/pandoc-crossref/commit/d786c849c54841c809f2f13bda841c038a865e03.patch?full_index=1"
    sha256 "df60d96e2e20f7d7d13582ebdbf690daff2cb1a05f130311cf6ef92459ca1691"
    type :unofficial
    resolves "https://github.com/lierdakil/pandoc-crossref/pull/510"
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