class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.1a.tar.gz"
  version "0.3.18.1a"
  sha256 "92c09c09d2008279884e3549fcb536fa578a51d7ca9a20a8c9a1792449a80ad8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7250102e9e90db482a0e1ae878b8a4a0e3e20d5482f6de0a10bddb32755ec562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a92ee92698b273216a9a9034c63cd00334c251c2d3a478f71aef80b2c61db24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbbb553522e81588eedf1c4630a661d66ac5e97fd553e1f69006597baf4594e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "47804392e92179ad516cb48f1d484b305e32c836e966332de93ca3a2bb48d610"
    sha256 cellar: :any_skip_relocation, ventura:       "4249d180111ba13e72fc975f08d64076a55792ae82c64e89b6752f6476b837ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4f9a201c0c4b0533f50818a74bcc3296fda0e469b9959dcf55a48f976dd1d9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
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