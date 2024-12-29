class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.1.tar.gz"
  sha256 "d41c7fc7e9f1fd3bff72d96c0693458aa18b338f65390692baf277c305f95ec4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d162bcce4c55bd1a2d2a40099893593ec6dbc5c41df9d84593fce444dd5fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "673133be289e57a36574d6e2f491e3346e385f832b611ae175280247de33c1ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "941ca59af3d7f24f63700399c2410975421e262ff88a367f6f3f2f3e0881bd4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9a08fe8d552cedba2fd1e17a82ff77da5ac738026ea5cc1b982061183d4777"
    sha256 cellar: :any_skip_relocation, ventura:       "e38878a0d191840523257eacbe1aae372a26d08d23ec1f561ebdc591417ddc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492887aac29ac862b534be705b0b7714e08675297c37927b9005500d4b38b52d"
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
    (testpath"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}pandoc -F #{bin}pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end