class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https:www.minizinc.org"
  url "https:github.comMiniZinclibminizincarchiverefstags2.9.1.tar.gz"
  sha256 "0b3927f4bc9a092c142ae4239a02060f2b76a7f563a3e36c878f74534729ea5f"
  license "MPL-2.0"
  head "https:github.comMiniZinclibminizinc.git", branch: "develop"

  bottle do
    sha256               arm64_sonoma:  "9dc18a5b551562b1dbf3703d137447c6c71797bd23b58d8e0560f8af8d1f4d9f"
    sha256               arm64_ventura: "1ed781032690bcb8153b9637d12ee09c5e61277ef0e323d05c6b6b4bf3a67036"
    sha256 cellar: :any, sonoma:        "1ac845a5f5d962b7122184ebccb7026472e582b6770d76643ffd304bef0d56eb"
    sha256 cellar: :any, ventura:       "f25d044824d2ef45266c8481f10c3d51e2c67655b3219210a365ef56f038c14b"
    sha256               x86_64_linux:  "e48677fcd5e7d188b2c3eb1022e4e8ae7f2ddc44cf3a0cc2ea8b169b5a1589b7"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}minizinc --solver cbc optimise.mzn").strip
  end
end