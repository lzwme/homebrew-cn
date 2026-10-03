class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://ghfast.top/https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25a.tar.gz"
  version "0.3.25a"
  sha256 "91712810bf91807869dbda35f5186cd4f39352c6201d5712c8f4ce1ac3691ab5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8baf63bdaf5a90cff63365481afa4de0ed53b9e1678cdb4bf080a1952ed6065f"
    sha256 cellar: :any, arm64_tahoe:       "0f656d96c2b4066a7cda1116e858c62836cc9fe09dc494231ccda73aa7032952"
    sha256 cellar: :any, arm64_sequoia:     "eb3f1d7443971a27ce678840fd0132edb5dafc8ec802f608c83023f2c9868722"
    sha256 cellar: :any, arm64_linux:       "f8b14d36dc80528f96b35ebf54d25e174ed5fa3c8a559695e3517ffde505e83b"
    sha256 cellar: :any, x86_64_linux:      "ab176e90248bfc3ec1d4ba4b633f848493ddab1cc7d4a87a803003a939142f5b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Relax the pandoc bound so the filter is compiled against pandoc 3.12
  patch do
    url "https://github.com/daeho-ro/pandoc-crossref/commit/5709f41df96ab5a7ca6d573e5695d10fc0db2928.patch?full_index=1"
    sha256 "6ad18e41d5b89dd58cf452ccc83a9a6f1dcbb16562a954c86e328ea0306ec43f"
    type :unofficial
    resolves "https://github.com/lierdakil/pandoc-crossref/pull/514"
  end

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
    output = shell_output("#{formula_opt_bin("pandoc")}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end