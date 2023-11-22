class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0.tar.gz"
  sha256 "a1933b7aba27ef352b7624d234980dc4c4b46ebb607e940c669c2a187e6c6426"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c78c07dcc9710f84acb458aaad67c5f7568f2f003e7719ae446add601e7140a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "184fed5fbe3e5e6380bf857fa5ab50cb296c6817168e6e15a9178227b9dc4c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12300a13921acddc747ad6a888e5ed74ff4b72d24c1f4bc61dca884e856bb7cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8434b1f67048f19e1cc957e5981f60b8504d63d26bfd38855b20b790882ad721"
    sha256 cellar: :any_skip_relocation, ventura:        "39a9a440e9370785e4b52ded4954e2cb0b3b68fb4155063d36b5092e30879294"
    sha256 cellar: :any_skip_relocation, monterey:       "f16b536aabd57d2407b2bd886f14afc44d8990e6d8bc68bd83808332810b6aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8981e3e3aa1f92e1f2dfcb8d0ff17a7f9b8bb21ce1270fed40687cd4114152a8"
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