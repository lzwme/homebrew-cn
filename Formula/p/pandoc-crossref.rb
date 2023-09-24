class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0f.tar.gz"
  version "0.3.16.0f"
  sha256 "1239cd17197f6685bf29e842d02618d0d2fd3220a469970f4200af5176638515"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec15390a12a1ffeacce43b59304757b262659013752964b4c10788220a32f12e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a097bd76f06fe2be2ab743765deff113e38e5a827688e646fb7d45cb75c372d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5c89e4ad8a8111584e1dca6e64319ef59593f7442a4892df5fb0c394fa4ca36"
    sha256 cellar: :any_skip_relocation, ventura:        "b04b8f05425a39eaf9cc8c83697b9babc661e976ceffa526f94a07cba17f8adc"
    sha256 cellar: :any_skip_relocation, monterey:       "945545f3e2881af6570effe78be3d1d68d39e27b1814d71bddfdbf7bc3b07696"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c113ed611ba38bcef45611b7c11d21cbd883a19d224037c705452b6f8eb140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84cf123b2da9ce19a55377afcfa52e5f7cffd1470ef0b2c3f64dbd7e963b5a9d"
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