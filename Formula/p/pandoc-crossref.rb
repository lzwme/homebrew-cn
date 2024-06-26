class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.1a.tar.gz"
  version "0.3.17.1a"
  sha256 "eb72c2473daa28ef27f351b7424f56d44cf86e433fac2853aac3054588e3049e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ab4ced175108f527f2c433f9611237cefd84a820858c50d6862b1f15b25ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9442c5c7d5593d243fa484d5743ff590264ad1be18819030b4db6d4befa6f1aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62adca57051d7a3e7ebc49b45f9a103ded6147ecfa91ee2bdf61b95ae7a5b581"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a6de68940531e42bc9f066e48791119d85445aafe68daeda44440c6875a7611"
    sha256 cellar: :any_skip_relocation, ventura:        "0eeba81d66b108d6df6604257fba047d5f7b34b8b3306a4ab981776d4ede50b3"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa6b3eededdf10695ef87a287996ca0c6d7876f8874d00f4d7d4e5a664f24c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d45ee5a01493f023dd32e870a1256030d2db79ad87d7de30286474ae9636aa"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm_f "cabal.project.freeze"

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