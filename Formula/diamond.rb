class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://ghproxy.com/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "29726e72f65cf2d8a3c183d858ce497ddc26cb1c9e09957f109da09669d3f718"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae0330c69fc066b3521e5d5fa2d90adbb64888ce4d9addf5f52776f812101bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093110045b8af53e233a9dc2e8be6de76fd0c6e81636b5be16eb7dd50b6001b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1440861e321fd91e9f9fb61ae3384df1be3ceab61cb48ec50fa1f7f7a8002b13"
    sha256 cellar: :any_skip_relocation, ventura:        "a7f04638a75b7c3a371c841fea0837e5d159ff2f5d1b83fe28f585d47d5c841a"
    sha256 cellar: :any_skip_relocation, monterey:       "8996b463b22328d10fc79e28bf13ac9bf807b18c640df41df6e1918ac94ddfd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d821c847c43b3897c422205d7bc053c80d416dfbe93ea025f238cb5dd92a0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292565d4c5219a132833f7579f5c21f1bc8a7c11582b81c349f7b2a6e8a516f9"
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