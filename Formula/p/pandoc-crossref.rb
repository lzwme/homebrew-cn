class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.1b.tar.gz"
  version "0.3.17.1b"
  sha256 "39e81ac089c23aa302ba3925147135df1425c63c5fe497b26f47e3c04789b638"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea253a9acc52534c9bfa7f05385b103d8506ecc56c6cd9c7f76b4a2bf7bdaae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "813c3b125b31a31b77cbc3c96a261ab1bd80a42a00773101807c4987b97c2f18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4913cd23bb0ed2f4891ecdf76dd2fcb1991273fb68303ade55851edd2a031d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be9f3d75c708281d9c98c057599738b9f097cdd63d3063f6434ba40842bec28"
    sha256 cellar: :any_skip_relocation, ventura:        "5317c834e38cbded5d487c41e8251af0ac01f6c9d795c8e3ee4da729aab515a5"
    sha256 cellar: :any_skip_relocation, monterey:       "7615c007eb1bbe27b74e139cce79bac576b62113b13f16b00e1cb658bfd8c4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae507e54307d81edee2261458f4a8cbcd1506b7f288806f86037c8a1c63762f"
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