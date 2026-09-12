class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.5.tar.gz"
  version "2.0.0-a.7.5"
  sha256 "bdc9942bb95b821eb7a665c46992be238209aff75fe1132c8cac68da90f19cc0"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fc114d175f81100a257bb63bd33b880cfacd60fd3e0adf474e3003c821a32337"
    sha256 cellar: :any, arm64_tahoe:       "d0663e214fa35428be3a98c565e41de488bfe0a4e1f05b530e19fd75a6510f6c"
    sha256 cellar: :any, arm64_sequoia:     "2bfa1699bffd886887cfdffba6de6944482b2a3ec5472d899d1f403931f5b492"
    sha256 cellar: :any, arm64_linux:       "884d6520d8dad01a89129a061f60588b9a0ffb43777726d367879c09ebd31f7a"
    sha256 cellar: :any, x86_64_linux:      "6fb2d7e39f97e2a96d127706402ac9f9be528eabbb1226ba95fcc090974fc197"
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