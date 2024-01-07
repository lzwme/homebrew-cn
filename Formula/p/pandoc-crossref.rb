class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.0b.tar.gz"
  version "0.3.17.0b"
  sha256 "6663e5fed9d3b18f7877e5dd98514520a55cfc3776e838be9daaaa16f7c04275"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1d17b4ece3b5c60b8dc442f36b0eccd6552614decdb32edd952e27e848d1c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e73f9247189a6d41e33e0ba6e118f6024e0a038a75e3fadc3bb75ecc6d03dd19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9617f5ff73e9337df40244f66549ccfad1f65c5cfefd2b66bf254af9f7bee4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df370e7bdf9c5858b77352c12e758fc7bcb046b38ebb825d8c1f954fd0c02ce"
    sha256 cellar: :any_skip_relocation, ventura:        "f1bd8eaac59317b85a23ab351235e5977a4f60c0551698c554a0a199116b3668"
    sha256 cellar: :any_skip_relocation, monterey:       "89d3a64f107327e73ca1ffac41e778b0c7a026b15e30dd826401fe7c0e32fb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ebe4c95a90cfbca1e044b4c3bfeb6c43a2202fa7d25a3e3396b063c0fe7bee"
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