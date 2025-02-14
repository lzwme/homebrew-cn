class Mummer < Formula
  desc "Genome alignment tool"
  homepage "https:github.commummer4mummer"
  url "https:github.commummer4mummerreleasesdownloadv4.0.1mummer-4.0.1.tar.gz"
  sha256 "bc20ae2701a0b2e323e4e515b7cfa18a0f0cb34a4ff5844b289b2de0154e3d3e"
  license "Artistic-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "531fd07a35db174253c4ef9793b769ef8fb9eda7c18665fcd910d1ecdc644d29"
    sha256 cellar: :any,                 arm64_sonoma:  "10ea871df20fefead713e4bd505c41b60d89f6baa3acc9a53608b53b9dba8bb7"
    sha256 cellar: :any,                 arm64_ventura: "6a0f7b4ad59e2edd7e2e1f5efd20fd1dc96ba70f8190450f9835c616591b5c49"
    sha256 cellar: :any,                 sonoma:        "6fafc17a6f92671ab3bbbe782da92288f0987d108ef6c919fb78832ec86054b5"
    sha256 cellar: :any,                 ventura:       "275577377003c87c3c04ac07992f7b508f107a30be3a5a9906c26243b0f07820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdbd99b231c881102c83c2f902dd3ab5c1b499ed27e9307baf5272e3439ff9b"
  end

  depends_on "gcc"

  fails_with :clang do
    cause <<~CAUSE
      Clang+libstdc++ seem to have issues:
        * the unittest for multi-threaded output fails
        * tools using multi-threaded output have incomplete and inconsistent output
    CAUSE
  end

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Align two small sequences with nucmer
    (testpath"seq1.fa").write <<~SEQ1
      >101
      ggtttatgcgctgttatgtctatggacaaaaaggctacgagaaactgtagccccgttcgctcggacccgcgtcattcgtcggcccagctctacccg
    SEQ1
    (testpath"seq2.fa").write <<~SEQ2
      >21
      ggtttatgcgctgttttgtctatggaaaaaaggctacgagaaactgtagccccgttcgctcggtacccgcgtcattcgtcggcccatctctacccg
    SEQ2
    cmdline = [bin"nucmer", "--sam-long", testpath"output.sam", "-l", "10", "seq1.fa", "seq2.fa"]
    result = <<~RESULT
      @HD\tVN:1.4\tSO:unsorted
      @SQ\tSN:101\tLN:96
      @PG\tID:nucmer\tPN:nucmer\tVN:#{version}\tCL:"#{cmdline.join(" ")}"
      21\t0\t101\t1\t30\t26M1D37M1I32M\t*\t0\t0\tggtttatgcgctgttttgtctatggaaaaaaggctacgagaaactgtagccccgttcgctcggtacccgcgtcattcgtcggcccatctctacccg\t*\tNM:i:4\tMD:Z:15a10^c59g9
    RESULT

    system(*cmdline)
    assert_equal result, (testpath"output.sam").read
  end
end