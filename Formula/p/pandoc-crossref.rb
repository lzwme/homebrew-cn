class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.0.tar.gz"
  sha256 "907facfa672e7069aacd97ce774b18f99e689e48d6b0c1ddfe3e31b99e9429e4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573171e87b11643f9498f2cf5810ba88d9ce2e8fb22b1125da8fa8fc938fdc65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b0efdc484d9f83d0946e3c9fa86f7cd22b477fdd387ac5b97b3934d0660092"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd19957578217a6c1b1522a08f7ea2734f8f0b5d620819d10b80d74936ef5ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4618d0cab68b3768b61d15ba1dc88734d93a4b1924ec82846a06094fdf1986"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b79f62e378a3e9d08bc5df65f092847962e368e5e540e732744b34e54a2f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4eff8a64c320f21f7162878ba9c23a665cfba734e6b2eccfe873ec683c0935"
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