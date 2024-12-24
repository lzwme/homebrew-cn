class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.0c.tar.gz"
  version "0.3.18.0c"
  sha256 "b82b3f5d78ca1ea1b406b126704a81d595db341fc6f757bdfbf9832415aec6a3"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f056f20a11b84bb96fb689dadb6fd0ab125f2f5fe422476eeab1ad9d44382ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c50277d4b20bb39c1aa54a2bda5b6f18db619478c624b2d4f45009c3bd17818"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33a6429bd5b91d917ca31ef01b9ad6153f11d52cead374e18edb88e2ae945348"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd78c513f5121100c4a9d63ac4097732f7fc5379ec4830a70d851e900e620b8"
    sha256 cellar: :any_skip_relocation, ventura:       "8502af029c963f94e1bafafe4b0b8841c9696f00065455bbfac9b9849616dcc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b2a23c95d277b6533b7c4a206f1d580a0f325772f80885d2ac0975ff02164c"
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