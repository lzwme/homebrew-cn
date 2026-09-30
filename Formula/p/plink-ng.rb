class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.10.tar.gz"
  version "2.0.0-a.7.10"
  sha256 "d012e340e6fbdabcc77b57cb2e0d0f20181a759eb268fc51d3418410d819a272"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d0ea9f01ce1c67bd57493f8ccd3df4c82f16307401ab83a6ca8bba4baaf51e39"
    sha256 cellar: :any, arm64_tahoe:       "e3fe7a077d301f274991e6e245d93126ddcc4275af2c777ef3cf18361261307c"
    sha256 cellar: :any, arm64_sequoia:     "261bccdc139f32c8b03853547ba70545ec38c9af6880bb4f486aac1e0d6de473"
    sha256 cellar: :any, arm64_linux:       "8c49abd8d55646b1a466c02ec53adbb9384d0546dd71c5e1a523fce9cdcee002"
    sha256 cellar: :any, x86_64_linux:      "147282fd813ed3a6aa49adedbbd6e1bd85814c49ce004a4e28ee276568e808bc"
  end

  depends_on "zstd"

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    cd "2.0/build_dynamic" do
      # Link against zstd rather than the bundled copy.
      args = ["STATIC_ZSTD="]
      # OpenBLAS ships LAPACK and LAPACKE, so a single -lopenblas is enough.
      args << "BLASFLAGS=-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?

      system "make", *args
      bin.install "plink2", "pgen_compress"
    end
  end

  test do
    # Simulate a small cohort, then check the generated genotype file is usable.
    system bin/"plink2", "--dummy", "50", "100", "--out", "dummy"
    assert_path_exists testpath/"dummy.pgen"

    system bin/"plink2", "--pfile", "dummy", "--freq", "--out", "freq"
    freqs = (testpath/"freq.afreq").read
    assert_match "ALT_FREQS", freqs
    assert_equal 101, freqs.lines.count

    system bin/"plink2", "--pfile", "dummy", "--make-bed", "--out", "binary"
    assert_path_exists testpath/"binary.bed"

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink2", "--pfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end