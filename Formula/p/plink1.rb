class Plink1 < Formula
  desc "Whole-genome association analysis toolset"
  homepage "https://www.cog-genomics.org/plink/1.9/"
  url "https://ghfast.top/https://github.com/chrchang/plink-ng/archive/refs/tags/v1.9.0-rc3.tar.gz"
  sha256 "faa07757dd814ce0692275e6c2247f76ece74f3f49c50e6f3e4cc3539e85fe39"
  license "GPL-3.0-or-later"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+-(?:b\.\d+(?:\.\d+)*|rc\d+))$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d16abde3fea24b093b23d6b5bb9158742b2677dfa2de88bc9e7472fe6225360"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c14d5d1ea6c074e076ce35ad25836a4cb922a0d30faa5d5673b76661d04b7a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "530cdfb5ffeff958a6eff92b3d75127a4d3d1c62d172f1017f576904900539fd"
    sha256 cellar: :any,                 arm64_linux:       "4700c6df4706cea9bcdb88907ccdf650dc94ac40613e593ee8cef4f677c3b5bb"
    sha256 cellar: :any,                 x86_64_linux:      "fd33d9b6a05733c0a336b903f9508942bf145cf78f6869ab3b001e768d9a04b3"
  end

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "putty", because: "both install a `plink` binary"

  deny_network_access!

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