class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25a.tar.gz"
  version "0.3.25a"
  sha256 "91712810bf91807869dbda35f5186cd4f39352c6201d5712c8f4ce1ac3691ab5"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ebd05d147a2f52286bccec8c868dbd241d4b4b4f41dc2cacd6365793274d92c"
    sha256 cellar: :any, arm64_tahoe:       "be4ec93920434bce010aab9f0bfbd742b9f4cbba83fde5ae070e2cf48edfd1d4"
    sha256 cellar: :any, arm64_sequoia:     "e57f817e38e6e2b957cfda3946b635364e1738c88713a676a57cbc48c2031bbd"
    sha256 cellar: :any, arm64_linux:       "f15192fa4edc7af44c700f5607046bf6378a33aa09b46dba6c76b1d87fa6842f"
    sha256 cellar: :any, x86_64_linux:      "11683f2de8bdc16d4f00267c7fe2df283a2ca6eda8132f92488fae4b97bf4248"
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

  # Upstream master commit the next patch is based on, needed for it to apply to the tag
  patch do
    url "https://github.com/lierdakil/pandoc-crossref/commit/5affbc9671a94c5a86f2a37b008ed2fd7d3e6793.patch?full_index=1"
    sha256 "cdc6c15443e7fc0d9b77360455703f934b7d6d45005416199a679190e91a8069"
    type :backport
    resolves "https://github.com/lierdakil/pandoc-crossref/pull/514"
  end

  # Relax the pandoc bound so the filter is compiled against pandoc 3.12.1
  patch do
    url "https://github.com/daeho-ro/pandoc-crossref/commit/1327e621d49481420a798ceabdccbefc16029be3.patch?full_index=1"
    sha256 "c6ceddaf67c2a895cd617ba98d7d08b42104d928e45be3adfa9a91321cc3e15e"
    type :unofficial
    resolves "https://github.com/lierdakil/pandoc-crossref/pull/514"
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
    output = shell_output("#{formula_opt_bin("pandoc")}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end