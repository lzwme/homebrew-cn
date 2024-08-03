class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.1b.tar.gz"
  version "0.3.17.1b"
  sha256 "39e81ac089c23aa302ba3925147135df1425c63c5fe497b26f47e3c04789b638"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "311e8797c8452b953874779ffd863e4aad8185c5fb39e43c2eaebbb6e4cd2b86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d0c53498ecff74a4da95e2b32e23eb7ed42b47f1bee6ac75e02d2a54d11a39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8cae507dfa56079e4c58c4fdf9e920551b978e6d00706af6d9ec27fa206c5b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4d6096fb81a38d84b102b556c01a0532d256c81c48f52b173f0e6a19607045b"
    sha256 cellar: :any_skip_relocation, ventura:        "c8cab4ec07bf17a8a424447d745dd6df8b9f9fe7fac6c021989de8d1018ae768"
    sha256 cellar: :any_skip_relocation, monterey:       "498530d3cc71549f39c514974cc845a28f9dffa227a8ac06e9d819a145fd95b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d2de663f2d3b6d6a462d8394f7903c36407220650b1fcd4c128cb9a40c3892"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # pandoc 3.3 support patch, upstream pr ref, https:github.comlierdakilpandoc-crossrefpull447
  patch do
    url "https:github.comlierdakilpandoc-crossrefcommitaecc631ecf871bf37e94e20010d92420d86ac30c.patch?full_index=1"
    sha256 "3fc40a218eef05e9a7c31a37967d374c114b53060026333a425101fdf41f10dc"
  end

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