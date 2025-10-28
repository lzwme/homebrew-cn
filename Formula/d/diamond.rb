class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.15.tar.gz"
  sha256 "8159e400bc2eea504199f0dae8ba82a6402546d4d2cd941012cdc13c7e651c66"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a734ea03e8d6e15b317eaf5d774d2dc48dc9a9cd580e951563adf4a675fe3326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df1953f7fd9e81230c9ccca9f3d7fb1d4b74a8355f3a06f2cd36545460ee88b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720597c06dc2f3798eef34038af4a32363a3dcbf60613a7c83810a851648ff14"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa3e03d71a7a33d5369ae944c7aa5721b7c39c66fd82a5932a52220bddd3283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79080d8742cabaa4cfe35eff49d5e4bcb359a5b03626054c01e340358fa53b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b553289c45c8469a51b2f44635ea9dd6a50f3e16752ce1bf6117b150ee94bbab"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # Fix to error: no member named 'uncaught_exception' in namespace 'std'; did you mean 'uncaught_exceptions'?
    if DevelopmentTools.clang_build_version >= 1700
      inreplace "src/util/log_stream.h",
                "!std::uncaught_exception()",
                "std::uncaught_exceptions() == 0"
    end

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