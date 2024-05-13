class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.1.tar.gz"
  sha256 "b6183dd15954100f6f7acbf49ea5f845f9c5f851f895eb4e805002b3cafdd875"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53dc3e67fad94aa9b5edc98612392e95a835b571137d9c11ef4fcf6e4093df86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "669fc5252852b9627947ea66aa1fb119f5f2aef36fdf6a3db996aa0a8f213f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "065539eb3da0cc9fe72c399afce35361c81ec9646c5f597a0ae572e58abfd378"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fff9301dc32ca021394b96b1e1e74d46f4a0c8c8b424f533807073b74b4f15c"
    sha256 cellar: :any_skip_relocation, ventura:        "da696bb39e4c3afc233eb731d51b832f11184c0802bdac40c2d33058e68b9561"
    sha256 cellar: :any_skip_relocation, monterey:       "b819b97764edf0e45e072c7d33957776cf0385a1caa854165bde8580e5d03984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f364e653ed0074300a6561253a03808567daa15a5e484dfb9a0a57e5d8ba2465"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # patch to support pandoc 3.2, upstream pr ref, https:github.comlierdakilpandoc-crossrefpull436
  patch do
    url "https:github.comlierdakilpandoc-crossrefcommit8036b214c397a883a4f7099dfca5c13a1ed40a2d.patch?full_index=1"
    sha256 "ce27409adea9a571bd7b33062b93c986e2df7608f064025c3e8c29b21600eb0a"
  end

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