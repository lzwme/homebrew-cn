class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.13.tar.gz"
  version "2.0.0-a.7.13"
  sha256 "d125cd76cc284aa41c133add511b5030413e764b40d731fd38588dbd5104c6f6"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5aa8e40a84ac05237d0b158ee88aa62b5e8eb70d3678d3531820cf765de99c2c"
    sha256 cellar: :any, arm64_tahoe:       "c9cde9ec4c5bb453b917b8cf2d38d076317368b99a2970d23bdc9b400c9260fa"
    sha256 cellar: :any, arm64_sequoia:     "944e5ccbda9ec52fe707276705e37febafb9367d104b4d8b9a3fab2ae17c8ad9"
    sha256 cellar: :any, arm64_linux:       "e59de55e920a62a66aadf83dec4670cfba5c0e0897a9e68ff2bdbf97a269043c"
    sha256 cellar: :any, x86_64_linux:      "76632573040309938beca71af4c2db6889a785ce1d0ec0a484e6558141a4107c"
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