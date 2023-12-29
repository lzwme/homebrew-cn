class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.0a.tar.gz"
  version "0.3.17.0a"
  sha256 "cda5bc22e3fed2201ab04f440eb86dc12c8deee4196ce54b63e88715e9a3dfa7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa176392109076d0fce354420dc004d918a403b8bbe5bb7439798be26f9bb6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "995ab4b88c393a5695046531d911f9a86395100bae1f9bce3abe1decf30c58ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d3ad762f7637d144fee5147d6fbaf470ea063820c31dcc5082a3ec638153f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "04dc2d2080e30bb95bd8c81a674af69def0ef9110a6c6c1c127a2df54600a93f"
    sha256 cellar: :any_skip_relocation, ventura:        "c1413fcc5068daa00c65e44f978e6e02833518984da0e99354c0ce280613bc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "f8f4c9df8d4ae458193370fd5ed29d0838c9429f4d8ab4f99e0ed18f963618dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fdb8d6be14c3b852faf4cc53af40ff7404c21211eb520e3dbcf5c5d548e94ac"
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