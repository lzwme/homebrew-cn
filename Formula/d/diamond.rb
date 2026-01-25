class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.21.tar.gz"
  sha256 "e83c042e20b20ec80c9f28875412156b29478e894182e8568006d8b84fff88e5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc356ee72b03c833b6dbb69987160a54f980f14e9469dfb659c62dfc98e3efe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f5d97371e7df896a4eb5bfcd03c457005c61bfc76357251d767f3b2d664080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a00cb756d355d44a24316e018b9914213577a97d0fd36186aed8d48161ba087"
    sha256 cellar: :any_skip_relocation, sonoma:        "66977c36402c5fa18194d3881488a4b08ee69c2b92c8f88b6913ee4c220d79aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be59840aad28e5be295b8f8505349ae4bd27e19881209e389ecf31b08d553cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52acaae4f62d4c4f1844dd4c82202ba1eefa590ac39cec2a639d2e3868b439d2"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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