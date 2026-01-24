class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.20.tar.gz"
  sha256 "d5a95172e9ec616b7d33e6bd903046893a05bcfefb721ba2ac3a485bbadc7178"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f693f773d5d30085a6735cf7ab22500ae86e0540ebca950b4edcb346ee75feac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb2e9e975c040a1e89fc9f7f8f4ccc485c9a5810b266d51103ceb4489f44ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc65086a4f2872664fbbc44ea6c6f973cc2188185d80afcb96bb8f765ffb393"
    sha256 cellar: :any_skip_relocation, sonoma:        "20c5a2bf34fe08a2dfb3504018e8e1d28c373d9a717d1ba9c02acd4a5f4315f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6dee316f0b691bdc594f44d82dee77d3e7805674bc048748d54cba09f759eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f4d002641de0885c7b886a3c159bb24e8c014c93b0e80bf541dc93b49acd16"
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