class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "cb42b8319a59f258fea191e4660b62bdd9a90a9099322ae0f17203bc5986498a"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "324f51ae57d677076f7a36986052066f846969088a6722c4ec1894250c4ba7a0"
    sha256 cellar: :any, arm64_sequoia: "73e895f103fd03cd74aafdbcadb48cec1c1f541cb2e5074f8c7e0fca6084ad81"
    sha256 cellar: :any, arm64_sonoma:  "6fb3ab3eaa52532b3f6fd00cb487f45736eea011765ec2825110c64ea23e1248"
    sha256 cellar: :any, arm64_linux:   "723f2fb89900739f7bf4c63d688df0ca4ccf6f96a648812bd8321449064682c8"
    sha256 cellar: :any, x86_64_linux:  "e205be5eac1315edb91c36335887be87be22149e6f4de4c7a6c4e160a3bfb361"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Relax the pandoc bound so the filter is compiled against pandoc 3.11
  patch do
    url "https://github.com/lierdakil/pandoc-crossref/commit/2e4c199871405b657f1643e7fe6249d884263051.patch?full_index=1"
    sha256 "ba6c6c180985c6668fe90bd4bb589a369774609ec140e8fa4916209548d22de2"
    type :unofficial
    resolves "https://github.com/lierdakil/pandoc-crossref/pull/513"
  end

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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