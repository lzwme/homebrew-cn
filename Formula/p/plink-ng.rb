class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.9.tar.gz"
  version "2.0.0-a.7.9"
  sha256 "aa3fe9a01f5b9378890c35fabfe52dbbb5fe11b524aa0ca018f97ffc08cfd1e8"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f16b57789db8d488e2f78e2cb6d001559ad1b83532a7a5d5e147a1469ba9e3a"
    sha256 cellar: :any, arm64_tahoe:       "9a8d69c0c90a9f99e4ffaa790de182b3bd78624599c57862f9efa13092b40218"
    sha256 cellar: :any, arm64_sequoia:     "940f9e5a1b655a7dce44624623fe8c7b534741790d959566a7704170ec880530"
    sha256 cellar: :any, arm64_linux:       "479aa6a3512f79d26bc75164908384ecf1e9874136db387d743ecaedb25b5e03"
    sha256 cellar: :any, x86_64_linux:      "0d9e47117f7bec5b2b3d6bc1ae30a1f78064bde6cd77e9af9575025618578da2"
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