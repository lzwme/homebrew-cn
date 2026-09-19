class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.7.tar.gz"
  version "2.0.0-a.7.7"
  sha256 "93afd3545d7075c7c68af0e20096e32911715ac46b783a951cb26852d6adf16b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4999e57e4f13af05d58fd7678c5e0ba24ef1fc035f63a96e780400c49a48a9b"
    sha256 cellar: :any, arm64_tahoe:       "f8b4eb6df4a15ba6c296d075f4f53b4f1ce2438653744bb31c5f66e7dfc9327e"
    sha256 cellar: :any, arm64_sequoia:     "30526aa25cc8c94d4935d8aadc4c61dd5c862d477a941b5095f4c235e948b9e0"
    sha256 cellar: :any, arm64_linux:       "1326c84fc51c0ba0729912118e96455be1af966bbb13d3a38b8cbb4a391e01b8"
    sha256 cellar: :any, x86_64_linux:      "39b6953fd9c593619fde340ecf728eb05c071beda9ce21f4c7a9fa3a7bcbe6f2"
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