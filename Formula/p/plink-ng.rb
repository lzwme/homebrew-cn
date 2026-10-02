class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.11.tar.gz"
  version "2.0.0-a.7.11"
  sha256 "6b83f2ff0a2d59ed9693c7270935d59893729f451831e60fc7b646d91042ddce"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f21558604b9c9514aefd7dde97b064501dc9fed20eeebd05ea765bddb61406a"
    sha256 cellar: :any, arm64_tahoe:       "2282ee662ad926a5a454de4cb98c5ded1a9592191b182be381938a4dfe3ff633"
    sha256 cellar: :any, arm64_sequoia:     "343be675a9a22998c208ff0ab71375b78cb3b856c2c008f7a104965638e62ae3"
    sha256 cellar: :any, arm64_linux:       "6812c638ed8bbb80b55bcc7c7883bc6983d70f432c4bc2e626210631e23eba04"
    sha256 cellar: :any, x86_64_linux:      "356a75b22af7bb082204d5ed8ecd91a9e5f4e0abdf6d58a647373ac4e68ef0ab"
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