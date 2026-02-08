class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.22.tar.gz"
  sha256 "065296879d1e769049b513f2a266933a3db42004d08987fa1260294a5d2cfe6d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba7748335f305813b946c79b910171021c85453362dd28d23ea6e1f6b987370a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc86dd933c4481fba00cb03dcb9119e49ac79c917f33074acf88b6157443646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c458ff3f55222acd475a00379c3f2ee20c009c44c5dc301a95413ce76ecff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb457e8bebe64eba0e97be05560826baaa49ecb8381db99f9f2d81110c4898f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc8de9934a620ba716ec57f936c0c57d2b16477a5ab39a0d7dc587175559682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41a36de144140749213d2de56de5cfc956188c701f1e74922361b96dffa5077"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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