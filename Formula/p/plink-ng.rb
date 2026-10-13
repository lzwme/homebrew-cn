class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.12.tar.gz"
  version "2.0.0-a.7.12"
  sha256 "c3cdbf42ab7b1cd09a482dbdb2d4595330a01213c3c58c3841aeac7b40ffd507"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b9cfe642a60a18b5b55a5282e1877dcc2b793208d6374a4f9e7c8a9bc6eca4a1"
    sha256 cellar: :any, arm64_tahoe:       "75af5b63d7140491fe56451182f273eb9593b888f81df60550bd60d5bfc1307f"
    sha256 cellar: :any, arm64_sequoia:     "ac980b12ba4020da18bc67c0022e5d261bc9cc2af0089aebd38ba87d2d4cd4b0"
    sha256 cellar: :any, arm64_linux:       "694474e099aa97e9d1f0f469c5a3c4f9878de716740f021095b547bf9f9c362e"
    sha256 cellar: :any, x86_64_linux:      "2b3798a7300b055b3240a57f5d5f40ebe7537d099f7d80bc5b9b93f93f2d9203"
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