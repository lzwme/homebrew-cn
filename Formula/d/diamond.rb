class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.13.tar.gz"
  sha256 "d3d093b77d0ad8914f3e94dc53b9b2684cb77990765e1a2fe93ad022c28930f5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5deb210bf9cb7790e85ba12423d470dfef522326f8048c57e30a9e077ccf827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5161c709bb96f99aecd0b33b584c5254b8d98ece89c40f6e17173f9ee4310ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0805fec734a034b56d786381f6e290536b547287284fe49d3c917db77c624df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "814fa54602ac1ead2779baec592af6a352bc63b47310ed4a882c595a0832147b"
    sha256 cellar: :any_skip_relocation, ventura:       "ddce693dee8ad251c30a4339cb78a1697c89adbcda25de9f0636137390a34d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855f41e69ca7de3e5ba0ed58f11109b579e5afde0263edc9d7611cb8fc508295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe0a2ed40864c1c5aab11e2d7eac871ace638d377ae3efc8cf93c9a3cd2cdfc"
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