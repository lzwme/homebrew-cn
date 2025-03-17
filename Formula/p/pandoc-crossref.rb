class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.1a.tar.gz"
  version "0.3.18.1a"
  sha256 "92c09c09d2008279884e3549fcb536fa578a51d7ca9a20a8c9a1792449a80ad8"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44ee0efaf9b3071c31a6e87363200dc5ba696544b529dd26d208de21bbef1be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f114ed10678173d03ec2f9e199892b11ae37e399a04e26f13d14af8c3557defd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a5fa9d51257a8b25680446976ce1937829216b5e595706eb9f2e346f0e1cb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1858a1008ff6054aa9aeaa28f662aa80fef953828ffb4c23861f659b3403eeed"
    sha256 cellar: :any_skip_relocation, ventura:       "525c8087117312d2cde134d99945d5ee6e3f3aa894f50f488477fa7c02ec986f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9c892dd5e8068e7cf62e4b571b05b397372cc439e832a14a189802ef36da31"
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