class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0f.tar.gz"
  version "0.3.16.0f"
  sha256 "1239cd17197f6685bf29e842d02618d0d2fd3220a469970f4200af5176638515"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eba32408c56eacd9f121bb54b203f2c0fb3458650ae649137a157fad99946985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82e450c181c7be781eba86d43fdb49269317dcf08b1b27e46934e5c099cc3162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c359561c38eeb1bbb485e82670ebc06df3482995ec8d5cd2c5ecb824c3b9e55"
    sha256 cellar: :any_skip_relocation, ventura:        "53e70a8827fea59fc85ede9901064b00d7225bd4e9e631636e5193eee241a1e7"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4f8902cb76ecd8189c0b290125198eebaf48b29b3e9e71496efcd0642d0b73"
    sha256 cellar: :any_skip_relocation, big_sur:        "433d9208388498041b97e35a783061f19e75123b7985d0c6b9c3ec74c4f3f196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e19b5a3bac229ae596df8727d5bfb6b985a3e1b995f1576fa54c0133eba5518"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end