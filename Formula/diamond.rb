class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://ghproxy.com/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "77e9ea5ca2eb01efa391970d6adad417cf3302ffac403cba638168938fe1befc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1fa8ff612c685e872e44d2eba4f7bc777f88fccc3f20f4680b8ac30dd0fe278"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4df31992839a092c54d86e0f3a3a65be686263cedc6b131e820c3eae3f4d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3696d0afe08022a1fadc4e85bec86eb0cf1413b49367fc0c2f71704a74fdb122"
    sha256 cellar: :any_skip_relocation, ventura:        "be195e24d1ed627fbf7456e7492fc3fad5e244dbe656155534adb869962afbf6"
    sha256 cellar: :any_skip_relocation, monterey:       "1168806da90e9b029fc9863551509f9b1a1146032a478ee59c436019d8066a47"
    sha256 cellar: :any_skip_relocation, big_sur:        "369fda2322bd22e6ae477d32188dc8de8f66bea666e40c52f3c793e4419d40b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cacf5349bbd0480dc38eb1cc27dd7c891fb89698317434864518f641f9bea04b"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"nr.faa").write <<~EOS
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf1
      grarwltpvipalweaeaggsrgqeietilantvkprlyXkyknXpgvvagacspsysgg
      XgrrmaXtreaelavsrdratalqpgrqsetpsqkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf2
      agrggsrlXsqhfgrprradhevrrsrpswltrXnpvstkntkisrawwrapvvpatrea
      eagewrepgrrslqXaeiaplhsslgdrarlrlkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf3
      pgavahacnpstlggrggritrsgdrdhpgXhgetpsllkiqklagrgggrlXsqllgrl
      rqengvnpgggacseprsrhctpawaterdsvskk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-1
      fflrrslalsprlecsgaisahcklrlpgsrhspasasrvagttgarhharlifvflvet
      gfhrvsqdgldlltsXsarlglpkcwdyrrepprpa
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-2
      ffXdgvslcrpgwsavarsrltassasrvhaillpqppeXlglqapattpgXflyfXXrr
      gftvlarmvsisXprdppasasqsagitgvshrar
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-3
      ffetesrsvaqagvqwrdlgslqapppgftpfsclslpsswdyrrppprpanfcifsrdg
      vspcXpgwsrspdlvirpprppkvlglqaXatapg
    EOS
    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr 2>&1")
    assert_match "Database sequences  6\n  Database letters  572", output
  end
end