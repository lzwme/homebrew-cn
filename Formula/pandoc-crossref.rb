class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0d.tar.gz"
  version "0.3.16.0d"
  sha256 "fb23c2db8ccb6ee9ca7eba83944a9e9d7730758daa2747b97bd5b62304dd41b7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a550c4427792109fb41374966f395fad9c71d8be6813ea34a93c220a2b86c84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a1bba2a0a1a5a430ab22783e3e735a64cff24ee4722f68c734de76b38bb2588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10ff2f844cb7709eafe1b55fbc4932e0744cf1fd29cd41734bab8d2603b519d4"
    sha256 cellar: :any_skip_relocation, ventura:        "41f29db33d0fb5097c334911fc559d6b3c85ee8713bc849d18f47df246157bef"
    sha256 cellar: :any_skip_relocation, monterey:       "2af3894534ab8dec5f0f6fdb7808fa6f9ab9e3767ba7ec580c5ec2ce20cc0147"
    sha256 cellar: :any_skip_relocation, big_sur:        "c182e6dd570ac1e45197d2db1481f10fb97e77132da5119cc1a1c34ab804a1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8f9932b565b62d530f299e2bc783d30e74b77baef925e5cb26566c2ad066a5"
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