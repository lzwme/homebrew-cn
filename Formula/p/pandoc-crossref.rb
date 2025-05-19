class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.2.tar.gz"
  sha256 "a7b95fcf6807c3092684cf622da87afa34df3c2e6655a20dd5c243390f5e5ffd"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89d79506f79302e402227f23ec4d9f23f220a38bf53f77bdaf694080a72ab818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c180355a580214c02cf5133002b43c417615db1f60a69c26557ff7e9c5ffdc45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7144ac324ad3fe3e8bb12ca67b99bbc6919699a9c6f37f6f669889e966676085"
    sha256 cellar: :any_skip_relocation, sonoma:        "a327bb7a8b571f07be80636ffb091ca099be13a66f3014d5e7b8ca3815f043e9"
    sha256 cellar: :any_skip_relocation, ventura:       "a35668f495a419c08af3d1d51cccb3225d9717d3aa60885986015e04f6384074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4820c7769fe2e28b5764cfcc97584ec1bae4f7486b322006adf471c8252c1d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4198b10e68f50420844a83b7688f4c4c57d5d06b065bd37bffefb5651fecf7e2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # support pandoc 3.7, upstream pr ref, https:github.comlierdakilpandoc-crossrefpull473
  patch do
    url "https:github.comlierdakilpandoc-crossrefcommitec8170da048712ecf354cb3a234e15c627d83568.patch?full_index=1"
    sha256 "af7159ce95aa90d7ff1723c64b4e0074d0734756dd44592406f8e0f94e7eab5b"
  end

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