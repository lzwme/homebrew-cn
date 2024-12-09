class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.0b.tar.gz"
  version "0.3.18.0b"
  sha256 "a71043e86104951815886d560dd1173308bd7f7e556ce80530b4de03c1bcd9a5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529b899af27e7778ff5e762fad3fb77b7ee6aacce63cf11cc3849fb38be2f3ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73def5c9460f4708d3dd5138ce14b81fb47db8bc3de24c2ed8f27c5c23e589c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce7aaab582930cd94a4a406f8e7ececf16a22cca2911bfdd2ee4297e7b593a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "b012c162341e52f7155ba779c5b5e33d71b35809e2a6967f97fd5b68dbba981b"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb8412a76f7c2dbf6471dc88497d817ff004d32d7bb12d1a76cdc57d7dc6d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1c6ca2c6ceeebcd967ac3bd71300750ce652ab877d9f721e5d5ad92be83fa2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # patch to support pandoc 3.6, upstream pr ref, https:github.comlierdakilpandoc-crossrefpull458
  patch do
    url "https:github.comlierdakilpandoc-crossrefcommitc4d4ec77a8dcb18acb502e9a0bfcdec08c4a8838.patch?full_index=1"
    sha256 "4150d8d076a79536368ada800d84dfca61a4c1799e7e834c5bb25a165ddaa571"
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