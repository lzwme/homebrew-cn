class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.0c.tar.gz"
  version "0.3.18.0c"
  sha256 "b82b3f5d78ca1ea1b406b126704a81d595db341fc6f757bdfbf9832415aec6a3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca2831f761d2b98e71b919e27ee5a12a256125102db43ef2ba0eb610e6b6929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0c18313570a677bdf882d9ac96cf3c00f49b5ab581b0c789e8a34f12617a3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d3eb5c04d1df2ea9c4cc76d59437f00d9258b7815263bbfc3558b7db827a090"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c4c4761e654740698dde2c4013e067efe6363ddb12c467561d31b76778ff1b"
    sha256 cellar: :any_skip_relocation, ventura:       "49b6950e9e2a7853b68dcef28f6c38da27015ec3693adab2a780a68b500d7266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975b40de009e18194e46e2b025ef1a04a616bcaa7a6abfafc3c581aee19ef949"
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