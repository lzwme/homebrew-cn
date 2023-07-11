class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghproxy.com/https://github.com/lierdakil/pandoc-crossref/archive/v0.3.16.0c.tar.gz"
  version "0.3.16.0c"
  sha256 "e4f235612e45a6e08f627aee3faf5f54f0deb32f7486c7c2af6026a724073366"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a53d938aefaa99e629d75aabb421c0a5556af594b23e50cc2816d5c6f067cfb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0fb84dac7a656091f36d3af0b581a001c38dd41335fdb983e1e19a2056e528"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a294a46bdab4993bac2b83953562bda527781da38bfac6a606cea8f96f07d0"
    sha256 cellar: :any_skip_relocation, ventura:        "61ab9458d9274ef660d850ea6545d7e9fbd68cf50b969ceedf62a70896042ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "2330cc6d7e941f78333b015f4b969e016804b84fdafb963e5e8ddbcc7d455fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "504718b0bb3161d88b9db2ac33c9f435e483dee9b6a5dddfa74b5c3083e29d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad9ccd9cf66f1265d173fe2d2910aa5f4945768d665b9d809b811055eb58c4f"
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