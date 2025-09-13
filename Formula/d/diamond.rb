class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "161a5f008a0a2f38fbe014abc0943d2b9b482510a3a64e4e3ab7230ddddd484e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5dbb4e5e6245e3264052ca57fe5b0d47100c02c7acb241716270e1150f3937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3cd9ddd5fb56ad384149bd93d8449e555e9baf90f46f88be8e86c48666898ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "942f4ef1ba277704334960d73e370c4b54efc498a997f42ffb272c174153cdb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8a29630ad50d1472dc9f013533d6d59e4b70e46285a882a837152d5e486d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1beede93f9550d4bb3967861d7bfdee08fcf15002e7feb3d8708525137bf04"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  # Fix to build error on macos
  patch do
    url "https://github.com/bbuchfink/diamond/commit/68963336dab5dd02a4ce5bf7a3e936cd919244b0.patch?full_index=1"
    sha256 "5522d188beb8c6296f3cd39f5ab0a7ce8dffce265f0e8a761b873368c75befb8"
  end

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