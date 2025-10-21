class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "a276ba571db8912debfc53fddae7cfd686f2c10c99755d55d433721fb3c4e021"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc3f801f624f2782bb3b934c5459b6f6e09e1b2babb2ad24bf605c784983893"
    sha256 cellar: :any,                 arm64_sequoia: "145b3abec2f4c540694dff1590a60eac5e0c4af2dd74ced23c9a8c0128d8db44"
    sha256 cellar: :any,                 arm64_sonoma:  "5833dbcf65ab4f79c560e05f38d9c8d0da75c09821636cb69f3a8cb9e1b931d6"
    sha256 cellar: :any,                 sonoma:        "ab1cd8499b415d37da01f3595979273c692e84faa962666ef5b7d0d6276d7335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bbb188ee3015d1de79c5ff102c76ec528e3152e60bd99531ecfb103a37e2ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af39ac33c7f109fd142ebbffbd0aacb4aea0d0ed925b127aaeeca3cac31f4f7b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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