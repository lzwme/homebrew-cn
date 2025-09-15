class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "b15407ec06508dd71afbdb69da47a0983b9926e4b7f4591b0f3a13e64b38a536"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c54bf0c92724f7764eab0aff1b060e6dbb6b6d3c82d0c4fefc2a1893a145943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32b3e54186ffc128a831170275fa662cc0105b62012473b8c16bdf0373f6942"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4b0e16051f2fd6e0c4e9ca60fc26a7208ed9329015d93017ce6cad48d1c040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d7fd6f4b89edd8b3a34e6f9f40cad91f9196d8b67b63b0bfabf8ddcbb7a7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0015b12642350223a5b9b66762e027001ac554cf07cdce598c6352437bbeb886"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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