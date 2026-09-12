class Chopper < Formula
  desc "Filter and trim long-read sequencing data by quality and length"
  homepage "https://github.com/wdecoster/chopper"
  url "https://ghfast.top/https://github.com/wdecoster/chopper/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ea85f59d91636eba2736e73161ed7c9b912f1f42cb7728f98c72a1b66478a8a6"
  license "MIT"
  head "https://github.com/wdecoster/chopper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54543d30921688fc6dbb88b6ace2624991a51c1d0989a7690ac57d2557cc6330"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53d4fe43ad6ff63424d745362608fbde7f2de2fcf12fe422e0ea17d34889efa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2bd48f66b5cde423ef9eba4a583df609c577e87401c09efa0f0277262791c1e"
    sha256 cellar: :any,                 arm64_linux:       "dba4ce09be1e1cfd9d7ce297773d3d122b17674869b32781026b67d1b1572d71"
    sha256 cellar: :any,                 x86_64_linux:      "b76c39a839f38d4cc88f1dafd29bb2a3c675ecfc8a900b97a4ac996902cdd7d3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # read1 is 32 bp, read2 is 4 bp; filtering for reads >= 10 bp drops read2
    (testpath/"reads.fq").write <<~EOS
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      ACGT
      +
      IIII
    EOS

    output = shell_output("#{bin}/chopper -l 10 -i reads.fq")
    assert_includes output, "read1"
    refute_includes output, "read2"
  end
end