class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.23a.tar.gz"
  version "0.3.23a"
  sha256 "7b3638c8b8d416f28e950cf650c52d3e961f53ce6cc640133caf8ee99b2efade"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcc0c04cee89e8b64dfc6a375435e827a6662c0ea34f902f2869bdb7acff4864"
    sha256 cellar: :any,                 arm64_sequoia: "f04c16c8ce3486e544f8cf71c63ad6249fb49297de84f4c3423782a6432712dc"
    sha256 cellar: :any,                 arm64_sonoma:  "80837bc0d92ed327217a4fd932fce76b457dd088fedf98c1830dfc4f3af9e7e5"
    sha256 cellar: :any,                 sonoma:        "8f453b22c706eff1e653c859d7c62bb7c403606043d849cd65295e237b49df0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57232e3b86978936a6ef517d2c8273008028010e0f34ceac211be5ebf3eb382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81427608e02bc74cfe4d81525d4a5f0aa3a6ff06f088a082611b73af9578d4d7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end