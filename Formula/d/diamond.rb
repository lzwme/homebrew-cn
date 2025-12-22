class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://ghfast.top/https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.17.tar.gz"
  sha256 "71d0bad8453823f25c92634d00cf8dac02972840a19f4d34783e1e52d2d13d77"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "531331f17e37ea06c0b6f33aea4d90229601e7509a6c285f9b6f64be77d199dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef84ff2de611955e8ff6e7d8a075322fb19795395b72be725da41cccb67dae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f48850d055f2114843083c791c6e5ccc45a38aaff65f44f0c5135c26fa0d250"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b1a020ee53978e824d92c3d1e5de0dd9c48908d985d100057e9e1aa5258649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4caa521e71ca8284e047106055647a41521a09bd7db345ee92a1ac1b3a0e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26759fd4515ed7fd5a5a1e3132f01eeba011bd735fd4be54adc7886d7b7fa09d"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    if DevelopmentTools.clang_build_version >= 1700
      # Fix to error: no member named 'uncaught_exception' in namespace 'std'; did you mean 'uncaught_exceptions'?
      inreplace "src/util/log_stream.h",
                "!std::uncaught_exception()",
                "std::uncaught_exceptions() == 0"
      # Fix to error: no matching function for call to object of type 'const __copy_n'
      # TransformIterator is not an input_iterator in C++20 iterator concepts
      inreplace "src/util/data_structures/flat_array.h",
                "data_.insert(data_.end(), begin, end);",
                "std::for_each(begin, end, [&](auto&& v){ data_.push_back(v); });"
    end

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