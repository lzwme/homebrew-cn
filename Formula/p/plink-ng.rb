class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.4.tar.gz"
  version "2.0.0-a.7.4"
  sha256 "370b8c6127deb5231b72a581f7869409db7fa314ef66e7b96553f621fdbe61a1"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c938bae3db2ac57b0a02c473b4e84c2446f9d47c4def1511d44bfc47a90e56e"
    sha256 cellar: :any, arm64_sequoia: "cebf9949bfed2c74805e614b72a50f6d8ecefbe0f11dff0ee4501a9004d8f870"
    sha256 cellar: :any, arm64_sonoma:  "7de1a595536c9622e00c172c30f922bb689e35b826f4cc13f76b4883ea04d1d8"
    sha256 cellar: :any, arm64_linux:   "62eae50f924b04b6dd3b363b15c7983cd6a787faed7d77e63de80ba090c2ae85"
    sha256 cellar: :any, x86_64_linux:  "a103ff4f1dcb3fb17ba7593336dd9148183803aea72c31ce11429b1116ec8662"
  end

  depends_on "zstd"

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

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