class Plink1 < Formula
  desc "Whole-genome association analysis toolset"
  homepage "https://www.cog-genomics.org/plink/1.9/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v1.9.0-rc1.tar.gz"
  sha256 "345ee8dcb9064f96a609b69dba4b285f0ae9a5ed6b4799b8a82b91330f11fc3a"
  license "GPL-3.0-or-later"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+-(?:b\.\d+(?:\.\d+)*|rc\d+))$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b043c1d6721a533649b44aba8ad029ccdde066f658b7c1b442b9f878410e28c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6aaade61eafed2c74bdcbaea0a6173df4e2ce0d8096ad17cb64d51c5dca01f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "424709073c0c2788cfffaa2f6b8675bd26214759952ec03b1cd4808ef3ec70f9"
    sha256 cellar: :any,                 arm64_linux:       "1ad05260d6bd7378d8de35553041633d210e471a7cd40cfb601980095b24e438"
    sha256 cellar: :any,                 x86_64_linux:      "5fd6576dcb1643c11cd5a7bdbb7d7936f95db4f346598b0080ab004259368e15"
  end

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "putty", because: "both install a `plink` binary"

  def install
    # PLINK 1.9 lives in the `1.9` subdirectory of the plink-ng repository.
    cd stable.version.major_minor.to_s do
      # Link against the system zlib rather than a vendored copy that is not
      # shipped in the release tarball.
      args = ["ZLIB=-lz"]
      # OpenBLAS ships LAPACK, so a single -lopenblas replaces the ATLAS default.
      args << "BLASFLAGS=-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?

      system "make", *args
      bin.install "plink"
    end
  end

  test do
    # Simulate a small cohort, then check the generated genotype file is usable.
    system bin/"plink", "--dummy", "50", "100", "--out", "dummy"
    assert_path_exists testpath/"dummy.bed"

    system bin/"plink", "--bfile", "dummy", "--freq", "--out", "freq"
    freqs = (testpath/"freq.frq").read
    assert_match "MAF", freqs
    assert_equal 101, freqs.lines.count

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink", "--bfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end